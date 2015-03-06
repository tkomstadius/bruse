class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # give access to helper methods
  helper_method [:current_user, :authenticate_user]

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    # Internal: Make sure user is logged in. Redirects to root if not.
    #
    # Examples
    #
    #   before_filter :authenticate_user!
    #
    # Returns nothing
    def authenticate_user!
      redirect_to root_url if !current_user
    end

end
