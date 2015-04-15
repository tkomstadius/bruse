class Files::FilesController < ApplicationController
  # make sure user is logged in
  before_filter :authenticate_user!
  before_filter :set_identity, except: [:download, :download_url, :show_all, :create_from_text]
  before_filter :set_file, only: [:destroy, :download_url]

  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :destroy_folder, :create_from_text]

  require 'dropbox_sdk'

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

  # Public: Create a file from a text string
  def create_from_text
    # check that current user has a local identity
    if current_user.local_identity
      # generate file name
      fileref = SecureRandom.uuid
      local_file_name = Rails.root.join('usercontent', fileref)
      # write to local file
      IO.write(local_file_name, text_params["content"])
      # automatically create a nice filename from content
      name = text_params["content"][0..10].downcase.gsub(/[^a-z0-9_\.]/, '_') + ".txt"
      # create the brusefile
      @file = BruseFile.new(name: name,
                            foreign_ref: fileref,
                            filetype: Mime::Type.lookup_by_extension('txt').to_s)

      # insert our file on the users local identity
      if current_user.local_identity.bruse_files << @file
        # send response that everything is ok!
        render status: :created
      else
        render status: :internal_server_error
      end
    else
      # no file! not working!
      @file = nil
      render status :not_acceptable
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

    def text_params
      params.require(:text).permit(:content)
    end
end
