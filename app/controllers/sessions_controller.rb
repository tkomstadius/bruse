class SessionsController < ApplicationController
  def create
    session[:user] = User.find_or_create_from_oauth(auth_hash, current_user)

    flash[:notice] = "Logged in"
    redirect_to root_url
  end

  def destroy
    session[:user] = nil

    flash[:notice] = "Logged out"
    redirect_to root_url
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
