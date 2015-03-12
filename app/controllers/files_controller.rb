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
    # are we adding file or folder?
    if params[:is_dir]
      # call to recursive file adding here
      @files = add_folder_recursive(params[:foreign_ref])
      # bulk save our files
      BruseFile.import @files
    else
      # add file!
      @files = add_file(file_params)
    end
  end

  def destroy
    # find file
    @file = BruseFile.find(params[:id])

    # make sure file belongs to current identity and delete file
    if @file.identity == @identity && @identity.user == current_user && @file.destroy
      @message = "File deleted."
      @file = nil
    else
      @message = "Could not delete file!"
    end
  end

  def index
    @files = @identity.bruse_files
  end

  private
    # Private: Set current identity from request parameters.
    def set_identity
      @identity = Identity.find(params[:identity_id])
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

    # Private: Add a folder and ALL it's children from Dropbox to BruseFile
    # model. It calls the add_file(params) method when it detects a file.
    #
    # Examples
    #   add_folder_recursive('path/to/folder')
    #   # => '[<BruseFile>, <BruseFile>, [<BruseFile>, <BruseFile>]]'
    #
    # Returns a list of new, UNSAVED, files
    def add_folder_recursive(path)
      # setup client
      @client = DropboxClient.new(@identity.token)
      # load directory contents
      dir = @client.metadata(path)

      # create empty array for file storing
      files = []

      # iterate over the directory's content
      dir['contents'].each do |file|
        # check if current child is a directory
        if file['is_dir']
          # add folder recursivly, and merge the results with our current files
          # array
          files.concat(add_folder_recursive(file['path']))
        else
          # prepare file data
          file_data = {
            # extract name from path
            :name => file['path'].split('/').last,
            # use path as foreign ref
            :foreign_ref => file['path'],
            # save file type
            :filetype => file['mime_type'],
            # save identity
            :identity => @identity
          }

          # create a file and push it to files list
          files << BruseFile.new(file_data)
        end
      end

      # return the list of files NOT YET saved to db
      return files
    end

    # Private: Add a file to BruseFile
    #
    # Returns a BruseFile record on success, nil on fail.
    def add_file(bruse_params)
      file = BruseFile.new(bruse_params)
      file.identity = @identity

      # could we save the file?
      unless file.save
        file = nil
      end

      # return the file
      file
    end
end
