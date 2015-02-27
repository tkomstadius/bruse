class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :ensure_login

  # we need the dropbox sdk here!
  require 'dropbox_sdk'

  def index
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(current_user["token"])
    # load files
    @files = @client.metadata(path)
  end
end
