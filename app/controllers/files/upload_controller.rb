class Files::UploadController < Files::FilesController
  # getting 'can't verify CSRF token authenticity'
  # this could be a serius problem in security?
  skip_before_filter :verify_authenticity_token, only: :upload_from_base64
  skip_before_filter :set_file

  require 'base64'

  def upload
    if params[:bruse_file].blank?
      flash[:notice] = "Choose a file"
      redirect_to bruse_files_path
    else
      @file = params[:bruse_file][:file]
      if @identity.name.downcase.include? "dropbox"
        file = BruseFile.new(upload_to_dropbox)

      elsif @identity.name.downcase.include? "google"
        file = BruseFile.new(upload_to_google)

      elsif @identity.name.downcase.include? "bruse"
        uploader = LocalFileUploader.new

        uploader.store!(@file)

        file = BruseFile.new(name: @file.original_filename,
                             foreign_ref: uploader.file.identifier,
                             filetype: uploader.content_type,
                             identity: current_user.local_identity)
      end

      if file.save!
        flash[:notice] = "#{params[:bruse_file][:file].original_filename} was saved in #{@identity.name}"
        redirect_to bruse_files_path
      else
        flash[:notice] = "Could not save the file!"
        redirect_to bruse_files_path
      end
    end
  end


  def upload_from_base64
    @results = []
    @errors = []
    params[:object][:data] = decode_file(params[:object][:data])
    @file = params[:object]
    if @identity.service.downcase.include? 'local'
      new_file = BruseFile.new(create_local_file)
    elsif @identity.service.downcase.include? 'dropbox'
      new_file = BruseFile.new(upload_to_dropbox)
    elsif @identity.service.downcase.include? 'google'
      new_file = BruseFile.new(upload_to_google)
    end

    # insert our file on the users local identity
    if @identity.bruse_files << new_file
      # send response that everything is ok!
      @results.push new_file.name
    else
      @errors.push "Could not save #{new_file.name}"
    end
  end

  private
    # Private: Decode file content
    #
    # file - the file content
    #
    # Returns decoded file
    def decode_file(file)
      Base64.urlsafe_decode64(file).force_encoding('utf-8')
    end

    # Private: Create a file containing dropped content
    #
    # content   - the file content
    #
    # Returns a BruseFile parameters
    def create_local_file
      if @file[:type] == 'text/uri-list'
        name = @file[:data].gsub(/(https?|s?ftp):\/\//, "").gsub(/(\/.*)*/, "")
        return {
          name: name,
          foreign_ref: @file[:data],
          filetype: @file[:type],
          identity: @identity
        }
      else
        fileref = SecureRandom.uuid
        # generate file name
        local_file_name = Rails.root.join('usercontent', fileref)
        # create file
        IO.write(local_file_name, @file[:data])
        return {
          name: @file[:name],
          foreign_ref: fileref,
          filetype: @file[:type],
          identity: @identity
        }
      end
    end

    # Private: Uploads the file to dropbox
    #
    # file - the file that's being uploaded
    #
    # returns BruseFile parameters
    def upload_to_dropbox
      response = @identity.upload_to_dropbox(identity_friendly_params)
      return {
        name: identity_friendly_params[:original_filename],
        foreign_ref: response["path"],
        filetype: response["mime_type"],
        identity: @identity
      }
    end

    # Private: Uploads the file to google drive
    #
    # file - the file that's being uploaded
    #
    # returns BruseFile parameters
    def upload_to_google
      response = @identity.upload_to_google(identity_friendly_params)
      return {
        name: identity_friendly_params[:original_filename],
        foreign_ref: response["id"],
        filetype: response["mimeType"],
        identity: @identity
      }
    end

    # Params suitable for the identity functions
    def identity_friendly_params
      begin
        Hash[:original_filename => @file[:name],
             :tempfile => @file[:data],
             :content_type => @file[:type]]
      rescue
        Hash[:original_filename => @file.original_filename,
             :tempfile => @file.tempfile,
             :content_type => @file.content_type]
      end
    end
end
