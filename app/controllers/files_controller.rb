class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!
  before_filter :set_identity, except: :download
  before_filter :set_file, only: [:destroy, :download_url]

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :destroy_folder]

  require 'dropbox_sdk'
  # require 'google/api_client'

  def new
  end

  def browse
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(@identity.token)
    # @client = Google::APIClient.new(@identity.token)
    # drive = client.discovered_api('drive', 'v2')

    # load files
    @file = @identity.browse(path)
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

  def destroy_folder
    if @identity.user == current_user
      files = @identity.bruse_files.where("foreign_ref LIKE (?)", params[:path] + '%')
      @success = true
      files.each do |file|
        @success = false unless file.destroy!
      end
    end
  end

  def index
    @files = @identity.bruse_files
  end

  # Public: generates a secure download url only accessable for
  # the owner.
  #
  # identity_id - gets owner of file
  # file_id - specified file
  #
  # Examples
  #   {identity_id: 1, file_id: 1} --> download_url
  #   # => @filepath # a secure unique url
  #
  def download_url
    if @file.identity.user == current_user
      @file.generate_download_hash
      @filepath = "get/#{@file.download_hash}/#{@file.name}"
    end
  end

  # Public: Sends requested file to user if the user has
  # the rights to download
  #
  # download_hash - unique hash for a file
  # name - name of the requested file
  # format - format of the file thats being downloaded
  #
  # Examples
  #   Get /get/lkajdflakjsdflhb/file.m
  #     # => downloads file.m
  #
  def download
    file = BruseFile.find_by(:download_hash => params[:download_hash])
    if file.identity.user == current_user
      # send the file to the user
      send_data file.identity.get_file(file.foreign_ref), :type => file.filetype
    end
  end

  private
    # Private: Set current identity from request parameters.
    def set_identity
      @identity = Identity.find(params[:identity_id])
      # make sure the identity belongs to this user
      unless @identity.user == current_user
        redirect_to root_url
      end
    end
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
