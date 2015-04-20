class Files::FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!
  before_filter :set_identity, except: [:download, :download_url, :show_all]
  before_filter :set_file, only: [:destroy, :download_url]

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :destroy_folder]

  require 'dropbox_sdk'
  require 'google/api_client'

  def show
  end

  def show_all
    @bruse_files = current_user.bruse_files
  end

  def new
  end

  def create
    # are we adding file or folder?
    if params[:is_dir]
      # call to recursive file adding here
      @files = @identity.add_folder_recursive(file_params)
    else
      # add file!
      @files = [@identity.add_file(file_params)]
    end
  end

  def destroy
    # make sure file belongs to current identity and delete file
    if @file.identity == @identity && @identity.user == current_user && @file.destroy
      @message = "File deleted."
      @file = nil
    else
      @message = "Could not delete file!"
    end
  end

  # Returns all files that have already been added
  # so that there is a reference list on the client side
  def index
    @files = @identity.bruse_files
  end

  protected
    # Protected: Set current identity from request parameters.
    def set_identity
      @identity = Identity.find(params[:identity_id])
      # make sure the identity belongs to this user
      unless @identity.user == current_user
        redirect_to root_url
      end
    end

    # Protected: Set file from request parameters
    def set_file
      @file = BruseFile.find(params[:id])
    end

    # Private: Safely extract file parameters from the scary internets
    #
    # Examples
    #
    #   file_params
    #   # => { name: 'hej.rb', foreign_ref: 'hej/hej.rb'}
    #
    # Return safer parameters
    def file_params
      params.require(:file).permit(:name, :foreign_ref, :filetype, :meta)
    end
end
