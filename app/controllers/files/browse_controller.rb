class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file

  def browse
    path = params[:path] || '/'

    # setup client
    # @client = DropboxClient.new(@identity.token)
    # @client = Google::APIClient.new(
    #   :application_name => 'Bruse',
    #   :application_version => '1.0.0'
    #   )

    # load files
    @file = @identity.browse(path)
  end
end
