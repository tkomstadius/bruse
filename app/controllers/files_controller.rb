class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :ensure_login

  def index
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(current_user["token"])

    # load files
    @file = @client.metadata(path)
    # remove eveything after the last '/' in the current dropbox path
    @parent_path = @file["path"].slice(0..(@file["path"].rindex('/')))
  end
end
