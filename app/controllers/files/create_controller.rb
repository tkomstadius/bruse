class Files::CreateController < Files::FilesController
  # Disable CSRF protection on create and destroy method, since we call them
  # using javascript. If we didn't do this, we'd get problems since the CSRF
  # params from rails isn't passed along.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  skip_before_action :verify_authenticity_token, only: :create

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

  protected
    # Protected: Safely extract file parameters from the scary internets
    #
    # Examples
    #
    #   file_params
    #   # => { name: 'hej.rb', foreign_ref: 'hej/hej.rb'}
    #
    # Return safer parameters
    def file_params
      params.permit(:name, :foreign_ref, :filetype, :meta, :link)
    end
end
