class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :ensure_login

  # disable CSRF protection on create method
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  require 'dropbox_sdk'

  def index
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(current_user["token"])

    # load files
    @file = @client.metadata(path)
    # remove eveything after the last '/' in the current dropbox path
    @parent_path = @file["path"].slice(0..(@file["path"].rindex('/')))
  end

  def create
    # logger.debug params

    # create dummy file
    @file = {id: 1, name: params[:name]}
  end

  def destroy
    # logger.debug params
    @file = nil
    @message = "File deleted."
  end
end
