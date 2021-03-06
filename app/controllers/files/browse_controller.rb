class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file

  def browse
    path = params[:path] || '/'

    # load files
    @file = @identity.browse(path)
  end
end
