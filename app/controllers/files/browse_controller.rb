class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file

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
end
