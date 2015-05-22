class Files::FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:destroy, :update]
  before_filter :set_identity, except: [:show_all, :update]
  before_filter :set_file, only: :destroy

  require 'dropbox_sdk'
  require 'google/api_client'

  def show
  end

  def show_all
    limit = params.has_key?(:limit) ? params[:limit] : 200
    offset = params.has_key?(:offset) ? params[:offset] : 0

    @bruse_file = BruseFile.new
    @bruse_files = current_user.bruse_files.includes(:tags).order(created_at: :desc).limit(limit.to_i).offset(offset.to_i)
  end

  def new
  end

  def destroy
    # make sure file belongs to current identity and delete file
    if @file.identity == @identity && @identity.user == current_user && @file.destroy
      if @file.destroy
        flash[:notice] = "#{@file.name} was deleted!"
      else
        flash[:notice] = "#{@file.name} was not deleted!"
      end
      redirect_to bruse_files_url
    else
      flash[:notice] = "Could not delete file!"
      @message = "Could not delete file!"
    end
  end

  # Returns all files that have already been added
  # so that there is a reference list on the client side
  def index
    @files = @identity.bruse_files
  end

  # PUT
  #
  # params:
  #   :bruse_file =>
  #     :id:integer
  #     :name:string
  #   :tags =>
  #     :names:string[]
  #
  # returns:
  #   :bruse_file =>
  #     partial files/files/_files.json
  #   :error:string if @error =>
  #
  def update
    @file = current_user.bruse_files.find(params[:bruse_file][:id])
    if @file.update(file_update_params)
      new_tags = []
      params[:tags].each do |tag_name|
        new_tags.push Tag.find_or_create_by(name: tag_name)
      end
      @file.tags = new_tags

      # save the changes
      unless @file.save!
        @error = "Error saving tags"
      end
    else
      @error = "Couldn't update file"
    end
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

  private
    def file_update_params
      params.require(:bruse_file).permit(:name)
    end
end
