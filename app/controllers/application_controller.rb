class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # give access to helper methods
  helper_method [:ensure_login, :current_user]

  private
    # Internal: Make sure user is logged in. Redirects to root if not.
    #
    # Examples
    #
    #   before_filter :ensure_login
    #
    # Returns nothing
    def ensure_login
      if session[:user].nil?
        flash[:notice] = "You need to log in first."
        redirect_to root_url
      end
    end

    # Internal: Get current signed in user
    #
    # Examples
    #
    #   current_user["email"]
    #   # => "name@example.com"
    #
    # Returns currently signed in user as hash object
    def current_user
      session[:user]
    end
end
