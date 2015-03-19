class Identity < ActiveRecord::Base
  belongs_to :user
  has_many :bruse_files
  validates_uniqueness_of :uid, :on => :create
  validates_presence_of [:uid, :token, :service, :name], :on => :create

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
  def self.find_or_create_from_oauth(auth_hash)
    identity = self.find_by(:uid => auth_hash[:info][:uid], :service => auth_hash[:provider])
    if !identity
      provider = (auth_hash[:provider].include? 'dropbox') ? 'Dropbox' : auth_hash[:provider]
      identity = Identity.new(:uid     => auth_hash[:info][:uid],
                              :token   => auth_hash[:credentials][:token],
                              :service => auth_hash[:provider],
                              :name    => "#{provider} - #{auth_hash[:info][:name]}")
    else
      identity.token = auth_hash[:credentials][:token]
    end
    identity.save!
    identity # return identity
  end

  require 'dropbox_sdk'

  def browse(path = '/')
    # set the client
    set_client
    # is it a dropbox service? return requested path!
    return @client.metadata(path) if service.downcase.include? "dropbox"
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
  def add_files(file_params)
    # are we adding file or folder?
    if file_params[:is_dir]

    else
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
  end

  private
    # Public: Get the file handling client from the identity
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
      if service.downcase.include? "dropbox"
        @client ||= DropboxClient.new(token)
      end
    end
end
