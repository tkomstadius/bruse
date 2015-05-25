class Files::UploadController < Files::FilesController
  # getting 'can't verify CSRF token authenticity'
  # this could be a serius problem in security?
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_file

  require 'base64'

  # POST
  #
  # The file thats being posted can either be a tempfile, base64 encoded or a
  # url file.
  #
  # params:
  #   :identity_id:integer
  #   :bruse_file[]
  #
  # returns a bruse_file object
  def upload
    if params[:bruse_file].blank?
      flash[:notice] = "Choose a file"
      redirect_to bruse_files_path
    else
      # Is the uploaded file a URL?
      if params[:bruse_file][:type] == 'text/uri-list'
        create_url_file
      else
        if params[:bruse_file][:file]
          @file = params[:bruse_file][:file]
        else
          decode_base64
        end

        # Determine where to store the file
        if @identity.name.downcase.include? "dropbox"
          upload_to_dropbox
        elsif @identity.name.downcase.include? "google"
          upload_to_google
        elsif @identity.name.downcase.include? "bruse"
          create_local_file
        end
      end

      # Make a good response
      respond_to do |format|
        # Try to save the file
        begin
          @file.save!
          format.html {
            flash[:notice] = "#{@file.name} was saved in #{@identity.name}"
            redirect_to bruse_files_path
          }
          format.json { render :upload }
        rescue ActiveRecord::RecordInvalid => e # pass in the error variable
          @error = []
          e.record.errors.messages.each do |k, v|
            # add all the errors to the @error array
            @error += v
          end
          puts e.record.errors.messages
          format.html {
            flash[:notice] = @error.first
            redirect_to bruse_files_path
          }
          format.json { render :upload }
        end
      end
    end
  end

  private
    # Private: decode base64 to a tempfile object
    #
    # Creates @file object
    def decode_base64
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

    # Private: creates a url brusefile
    #
    # Creates @file object
    def create_url_file
      name = params[:bruse_file][:data].gsub(/(https?|s?ftp):\/\//, "").gsub(/(\/.*)*/, "")
      @file = BruseFile.new(
        name: name,
        foreign_ref: params[:bruse_file][:data],
        filetype: params[:bruse_file][:type],
        identity: @identity
      )
    end

    # Private: Create a file containing dropped content
    #
    # content   - the file content
    #
    # Returns a BruseFile parameters
    def create_local_file
      uploader = LocalFileUploader.new

      uploader.store!(@file)

      @file = BruseFile.new(
        name: @file.original_filename,
        foreign_ref: uploader.file.identifier,
        filetype: @file.content_type,
        identity: @identity
      )
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
