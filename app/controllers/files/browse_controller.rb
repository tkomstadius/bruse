class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file
  skip_before_filter :set_identity, only: :upload
  # getting 'can't verify CSRF token authenticity'
  # this could be a serius problem in security?
  skip_before_filter :verify_authenticity_token
  before_filter :decode_file
  require 'base64'

  def browse
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(@identity.token)

    # load files
    @file = @identity.browse(path)
  end


  def upload
    uploader = LocalFileUploader.new

    uploader.store!(params[:bruse_file][:file])

    file = BruseFile.new

    file.foreign_ref = uploader.file.identifier

    file.name = params[:bruse_file][:file].original_filename
    file.filetype = uploader.content_type

    file.identity = current_user.identities.find_by(:service => "local")

    if file.save #file.identity.bruse_files << file
        flash[:notice] = "#{file.name} was saved!"
        redirect_to bruse_files_path
    else
      flash[:notice] = "you must log in to your bruse acount!"
        redirect_to bruse_files_path
    end
  end

  def decode_file
    decoded_content =  Base64.urlsafe_decode64(params[:data])
    IO.write(params[:name], decoded_content)
  end

end
