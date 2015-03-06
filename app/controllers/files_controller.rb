class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!
  before_filter :set_identity

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  require 'dropbox_sdk'

  def new
    @identity = Identity.find(params[:identity_id])
  end

  def browse
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(@identity.token)

    # load files
    @file = @client.metadata(path)
    # remove eveything after the last '/' in the current dropbox path
    @parent_path = @file["path"].slice(0..(@file["path"].rindex('/')))
  end

  def create
    @file = BruseFile.new(file_params, identity: @identity)
    @file.identity = @identity

    unless @file.save
      @file = nil
    end
  end

  def destroy
    # logger.debug params
    @file = nil
    @message = "File deleted."
  end

  private
    def set_identity
      @identity = Identity.find(params[:identity_id])
    end
    def file_params
      params.require(:file).permit(:name, :foreign_ref, :filetype, :meta)
    end
end
