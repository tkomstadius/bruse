class SessionsController < ApplicationController
  def create
    session[:user_id] = User.find_or_create_from_oauth(auth_hash, current_user).id

    flash[:notice] = "Logged in"
    redirect_to profile_url
  end

  def destroy
    session[:user_id] = nil

    flash[:notice] = "Logged out"
    redirect_to root_url
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
