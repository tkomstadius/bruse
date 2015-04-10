class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file
  skip_before_filter :set_identity, only: :upload

  def browse
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(@identity.token)

    # load files
    @file = @identity.browse(path)
  end

  def destroy_folder
    if @identity.user == current_user
      files = @identity.bruse_files.where("foreign_ref LIKE (?)", params[:path] + '%')
      @success = true
      files.each do |file|
        @success = false unless file.destroy!
      end
    end
  end

  def upload
    uploader = LocalFileUploader.new


    uploader.store!(params[:bruse_file][:file])


    file = BruseFile.new
    file.foreign_ref = uploader.file.file

    # file.name = uploader.filename
    # file.type = uploader.content_type



    redirect_to bruse_files_path
  end
end
