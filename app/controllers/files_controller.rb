class FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!
  before_filter :set_identity, except: :download
  before_filter :set_file, only: [:destroy, :download_url]
  before_filter :set_client, only: [:browse, :download_url]

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  require 'dropbox_sdk'
  require 'rubygems'
  require 'google/api_client'
  require 'launchy'

  def new
  end

  def browse
    path = params[:path] || '/'

    # setup client
    # @client = DropboxClient.new(@identity.token)
    # @client = Google::APIClient.new
    # @drive = @client.discovered_api('drive')
   
    # # Request authorization
    # @client.authorization.client_id = ''
    # @client.authorization.client_secret = ''
    # @client.authorization.scope = 'https://www.googleapis.com/auth/drive'
    # @client.authorization.redirect_uri = @client.authorization.authorization_uri

    # Exchange authorization code for access token
    # $stdout.write  "Enter authorization code: "
    # @client.authorization.code = gets.chomp
     uri = @client.authorization.authorization_uri
  Launchy.open(uri)

  # Exchange authorization code for access token
  $stdout.write  "Enter authorization code: "
  @client.authorization.code = gets.chomp
  @client.authorization.fetch_access_token!
    # Insert a file
    file = @drive.files.insert.request_schema.new({
      'title' => 'My document',
      'description' => 'A test document',
      'mimeType' => 'text/plain'
    })

    media = Google::APIClient::UploadIO.new('document.txt', 'text/plain')
    result = client.execute(
      :api_method => drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        'alt' => 'json'})

    # Pretty print the API result
    jj result.data.to_hash

    byebug

    # load files
    @file = @client.execute(api_method: drive.files.list)
    byebug
    # remove eveything after the last '/' in the current dropbox path
    # @parent_path = @file["path"].slice(0..(@file["path"].rindex('/')))
    byebug
  end

  def create
    @file = BruseFile.new(file_params)
    @file.identity = @identity

    unless @file.save
      @file = nil
    end
  end

  def destroy
    if @file.identity == @identity && @file.destroy
      @message = "File deleted."
      @file = nil
    else
      @message = "Could not delete file!"
    end
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
      # creates a dropbox client
      set_client(file.identity)
      # send the file to the user
      send_data @client.get_file(file.foreign_ref), :type => file.filetype
    end
  end

  private
    def set_identity
      @identity = Identity.find(params[:identity_id])
    end
    def set_file
      @file = BruseFile.find(params[:id])
    end
    def set_client(id = nil)
      identity = id ? id : @identity
      if identity.service.downcase.include? "dropbox"
        @client = DropboxClient.new(identity.token)
      end
      if identity.service.downcase.include? "google"
        @client = ::Google::APIClient.new(
          application_name: 'Bruse',
          application_version: '1.0.0'
        )
        @drive = @client.discovered_api('drive')
   
        # Request authorization
        @client.authorization.client_id = ''
        @client.authorization.client_secret = ''
        @client.authorization.scope = 'https://www.googleapis.com/auth/drive'
        @client.authorization.redirect_uri = 'http://localhost:3000/auth/google_oauth2/callback'
      end
      byebug
    end
    def file_params
      params.require(:file).permit(:name, :foreign_ref, :filetype, :meta)
    end
end
