class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file
  skip_before_filter :set_identity, only: :upload
  # getting 'can't verify CSRF token authenticity'
  # this could be a serius problem in security?
  skip_before_filter :verify_authenticity_token, only: [:upload_from_base64]
  require 'base64'

  def browse
    path = params[:path] || '/'

    # setup client
    @client = DropboxClient.new(@identity.token)
    @client = Google::APIClient.new(
      :application_name => 'Bruse',
      :application_version => '1.0.0'
      )

    # load files
    @file = @identity.browse(path)
  end


  def upload
    uploader = LocalFileUploader.new

    uploader.store!(params[:bruse_file][:file])

    file = BruseFile.new(name: params[:bruse_file][:file].original_filename,
                         foreign_ref: uploader.file.identifier,
                         filetype: uploader.content_type,
                         identity: current_user.local_identity)

    if file.save #file.identity.bruse_files << file
        flash[:notice] = "#{file.name} was saved!"
        redirect_to bruse_files_path
    else
      flash[:notice] = "you must log in to your bruse acount!"
        redirect_to bruse_files_path
    end
  end


  def upload_from_base64
    uploader = LocalFileUploader.new

    fileref = SecureRandon.uuid
    # create file
    decoded_content =  Base64.urlsafe_decode64(params[:data])
    IO.write(params[:name], decoded_content)

    if params[:location] == 'local'
      file = BruseFile.new
      
      file.name =  params[:name],
      file.foreign_ref = fileref,
      file.filetype = params[:type],
      file.identity =  current_user.identities.find_by(:service => "local")
      
      if file.save #file.identity.bruse_files << file
        flash[:notice] = "#{file.name} was saved!"
        redirect_to bruse_files_path
      else
        flash[:notice] = "you must log in to your bruse acount!"
        redirect_to bruse_files_path
    end
    elsif params[:location] == 'dropbox'
    elsif params[:location] == 'drive'
    else
      flash[:notice] = "something is really wrong"
    end
  end

end
