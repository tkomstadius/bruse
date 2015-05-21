class Identity < ActiveRecord::Base
  # relations
  belongs_to :user
  has_many :bruse_files

  # validations
  validates_uniqueness_of :uid, :on => :create
  validates_presence_of [:uid, :token, :service, :name], :on => :create

  # before actions
  before_destroy :delete_files
  before_destroy :update_default_identity

  # Public: Creates or finds an identity from oauth information
  #
  # auth_hash  - Hash with information from omniauth
  #
  # Examples
  #
  #   Identity.find_or_create_from_oauth(auth_hash)
  #   # => Identity
  #
  # Returns an identity object

  # Apparantly :uid => auth_hash[:info][:uid] doesn't work for drive, so I changed it to
  # :uid => auth_hash[:uid]
  def self.find_or_create_from_oauth(auth_hash)
    identity = self.find_by(:uid => auth_hash[:uid], :service => auth_hash[:provider])
    if !identity
      provider = "Dropbox" if auth_hash[:provider].downcase.include? 'dropbox'
      provider = "Google Drive" if auth_hash[:provider].downcase.include? 'google'

      identity = Identity.new(:uid => auth_hash[:uid],
                              :token   => auth_hash[:credentials][:token],
                              :service => auth_hash[:provider],
                              :name    => "#{provider} - #{auth_hash[:info][:name]}")
    else
      identity.token = auth_hash[:credentials][:token]
    end
    identity.save!
    identity # return identity
  end

  def unlink
    if self.user.identities.length == 1 && !self.user.own_password
      self.user.destroy
    else
      self.destroy
    end
  end

  require 'dropbox_sdk'
  require 'google/api_client'

  # Public: Browse this identity's file system
  #
  # path  - the path do browse
  #
  # Examples
  #
  #   file_info = browse('path/with/folders')
  #   # => {name: 'path/with/folders', contents: [<file>,<file>,<file>,<file>]}
  #
  # Returns the client's info about the path
  def browse(path)
    # set the client
    set_client
    # is it a dropbox service? return requested path!
    return @client.metadata(path)['contents'] if service.downcase.include? "dropbox"

    # is it a google service? Get files and return items
    if service.downcase.include? "google"
      # Get files depending on search path
      if(path == '/')
        @result = @client.execute(
          :api_method => @drive.files.list,
          :parameters => { 'maxResults' => '1000',
            :q => %('root' in parents and trashed=false)})
      else
        @result = @client.execute(
          :api_method => @drive.files.list,
          :parameters => { 'maxResults' => '1000',
            :q => "'"+path+"'"+' in parents and trashed=false'})
      end

      # Rename parameters for easy access
      @result.data.items.each do |f|
        if f.mime_type.include? "folder"
          f["is_dir"] = true
        else
          f["is_dir"] = false
        end
      end
      @result.data.items.map{ |f| f["name"] = f["title"] }
      @result.data.items.map{ |f| f["path"] = f["id"] }

      return @result.data.items if service.downcase.include? "google"
    end
  end

  # Add new files to the current identity
  #
  # file_params - the file parameters
  #
  # Examples
  #
  #   @file = @identity.add_files(file_parameters)
  #   # => <#BruseFile...>
  #
  # Returns the file/list of files
  def add_file(file_params)
    # append a new file to our the current identity's list of bruse_files

    file = BruseFile.new(file_params)

    if bruse_files << file
      # return file
      file
    else
      # could not append file!
      file.destroy
      nil
    end
  end

  # Public: Add folder and all of its contents
  #
  # folder_params - the folder to add, needs to contain the :foreign_ref parameter
  #
  # Examples
  #   add_folder_recursive('path/to/folder')
  #   # => '[<BruseFile>, <BruseFile>, [<BruseFile>, <BruseFile>]]'
  #
  # Returns list of added files
  def add_folder_recursive(folder_params)
    folder = browse(folder_params[:foreign_ref])

    # prepare file array
    files = []

    folder.each do |child|
      # prepare child parameters
      child_params = extract_file_params(child)
      # check if it is a directory or not
      if is_dir?(child)
        # concat merges two arrays, use extract method below
        files.concat(add_folder_recursive(child_params))
      else
        # add new file
        files << add_file(child_params)
      end
    end

    # return list of added files
    files
  end

  # Download file from identity's service
  #
  # foreign_ref - the service's way to keep track of the file
  #
  # Examples
  #   file_data = @identity.get_file(path_to_image)
  #   # => <image data>
  #
  # Returns the actual file data
  def get_file(foreign_ref)
    set_client

    # return file data
    return @client.get_file(foreign_ref) if service.downcase.include? "dropbox"
    return @client.execute(:uri => 'https://www.googleapis.com/drive/v2/files/'+foreign_ref+'?alt=media').body if service.downcase.include? "google"
    return File.read(Rails.root.join('usercontent', foreign_ref)) if service == "local"
  end

  def upload_to_dropbox(file)
    set_client

    self.user.default_identity_id = self.id
    self.user.save!
    
    response = @client.put_file("/Bruse/#{file.original_filename}", file.tempfile)

    puts "uploaded:", response.inspect

    return response
  end


  def upload_to_google(localFile)
    set_client
    
    self.user.default_identity_id = self.id
    self.user.save!

    drive = @client.discovered_api('drive', 'v2')

    # Search for parent folder
    folder = @client.execute(
      :api_method => drive.files.list,
      :parameters => {:q => %(title='Bruse' and 'root' in parents and 
                mimeType contains 'folder' and trashed=false)})
    
    # Parent folder not found
    if (folder.status != 200) || folder.data.items.empty?
      f = drive.files.insert.request_schema.new({
        'title' => 'Bruse',
        'description' => 'Bruse files',
        'mimeType' => 'application/vnd.google-apps.folder'
      })
      # Set the parent folder.
      f.parents = [{'id' => 'root'}]

      folder = @client.execute(
      :api_method => drive.files.insert,
      :body_object => f)

      folder_id = folder.data.id
    else
      folder_id = folder.data.items[0].id
    end

    # Set file information
    file = drive.files.insert.request_schema.new({
      'title' => localFile.original_filename.to_s.force_encoding("UTF-8"),
      'description' => localFile.tempfile.to_s.force_encoding("UTF-8"),
      'mimeType' => localFile.content_type.to_s.force_encoding("UTF-8")
    })

    # Set parent folder
    file.parents = [{'id' => folder_id}]
    
    media = Google::APIClient::UploadIO.new(localFile, localFile.content_type,localFile.original_filename )

    result = @client.execute(
      :api_method => drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        'alt' => 'json'})

      return result.data
  end


  private
    # Private: Get the file handling client from the identity
    #
    # path  - The path to browse, defaults to root
    #
    # Examples
    #
    #   dropbox_identity.get_client
    #   # => DropboxClient.new
    #
    # Returns the client
    def set_client
      @client ||= DropboxClient.new(token) if service.downcase.include? "dropbox"

      if service.downcase.include? "google"
        @result = Array.new{Array.new}
        @client ||= Google::APIClient.new(
          :application_name => 'Bruse',
          :application_version => '1.0.0'
          )
        @drive = @client.discovered_api('drive', 'v2')
        # Get authorization for drive
        @client.authorization.access_token = token
      end
    end

    # Extract BruseFile params from pristine file object from service
    #
    # pristine  - untouched service file object
    #
    # Examples
    #
    #   file_params = extract_file_params(untouched)
    #   # => {name: '', foreign_ref: ''}
    #
    # Returns the file params, prepared for db insertion
    def extract_file_params(pristine)
      if service.downcase.include? "dropbox"
        file_params = {
          # extract name from path
          :name => pristine['path'].split('/').last,
          # use path as foreign ref
          :foreign_ref => pristine['path'],
          # save file type
          :filetype => pristine['mime_type']
        }
        # return file params
        return file_params
      end
    end

    # Private: Check if pristine remote file object is a child
    #
    # Examples
    #
    #   is_dir?(child_object_that_is_a_folder)
    #   # => true
    #
    #   is_dir?(child_object_that_is_an_image)
    #   # => false
    #
    # Returns boolean
    def is_dir?(pristine)
      return pristine['is_dir'] if service.downcase.include? "dropbox"
    end

    # Private: Deletes all files owned by the identity on destroy.
    def delete_files
      self.bruse_files.each do |file|
        file.destroy
      end
    end

    def update_default_identity
      user.default_identity_id = nil if user.default_identity_id == id
      user.save!
    end
end
