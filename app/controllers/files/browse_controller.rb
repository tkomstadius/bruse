class Files::BrowseController < Files::FilesController
  skip_before_filter :set_file
  skip_before_filter :set_identity, only: :upload

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
    identity = Identity.find(params[:service])
      if identity.name.downcase.include? "dropbox"

        response = identity.upload_to_service(params[:bruse_file][:file])

        if response
          flash[:notice] = "#{params[:bruse_file][:file].original_filename} was saved in dropbox"
          redirect_to bruse_files_path
        else
          flash[:notice] = "Could not save the file!"
          redirect_to bruse_files_path
        end

      else
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
  end


end
