class Files::UploadController < Files::FilesController
  # getting 'can't verify CSRF token authenticity'
  # this could be a serius problem in security?
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_file

  require 'base64'

  def upload
    if params[:bruse_file].blank?
      flash[:notice] = "Choose a file"
      redirect_to bruse_files_path
    else
      if params[:bruse_file][:file]
        @file = params[:bruse_file][:file]
      else
        # create a tempfile from drag and drop upload
        file_data = Tempfile.new(params[:bruse_file][:name])
        file_data.binmode
        file_data.write Base64.decode64(params[:bruse_file][:data])

        # mimic an uploadfile to be able to continue with the upload
        @file = ActionDispatch::Http::UploadedFile.new({
          :filename => params[:bruse_file][:name],
          :content_type => params[:bruse_file][:type],
          :tempfile => file_data
        })
      end
      if @identity.name.downcase.include? "dropbox"
        upload_to_dropbox
      elsif @identity.name.downcase.include? "google"
        upload_to_google
      elsif @identity.name.downcase.include? "bruse"
        uploader = LocalFileUploader.new

        uploader.store!(@file)

        @file = BruseFile.new(name: @file.original_filename,
                              foreign_ref: uploader.file.identifier,
                              filetype: uploader.content_type,
                              identity: current_user.local_identity)
      end

      respond_to do |format|
        if @file.save!
          flash[:notice] = "#{@file.name} was saved in #{@identity.name}"
          format.html { redirect_to bruse_files_path }
          format.json { render :upload }
        else
          @error = ["Could not save the file!"]
          flash[:notice] = "Could not save the file!"
          format.html { redirect_to bruse_files_path }
          format.json { render :upload }
        end
      end
    end
  end

  private
    # Private: Create a file containing dropped content
    #
    # content   - the file content
    #
    # Returns a BruseFile parameters
    def create_local_file
      if @file.content_type == 'text/uri-list'
        name = @file[:data].gsub(/(https?|s?ftp):\/\//, "").gsub(/(\/.*)*/, "")
        return {
          name: name,
          foreign_ref: @file[:data],
          filetype: @file[:type],
          identity: @identity
        }
      else
        uploader = LocalFileUploader.new

        uploader.store!(@file)

        return {
          name: @file.original_filename,
          foreign_ref: uploader.file.identifier,
          filetype: @file.content_type,
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
      response = @identity.upload_to_dropbox(@file)
      @file = BruseFile.new(
        name: @file.original_filename,
        foreign_ref: response["path"],
        filetype: response["mime_type"],
        identity: @identity
      )
    end

    # Private: Uploads the file to google drive
    #
    # file - the file that's being uploaded
    #
    # returns BruseFile parameters
    def upload_to_google
      response = @identity.upload_to_google(@file)
      @file = BruseFile.new(
        name: @file.original_filename,
        foreign_ref: response["id"],
        filetype: response["mimeType"],
        identity: @identity
      )
    end
end
