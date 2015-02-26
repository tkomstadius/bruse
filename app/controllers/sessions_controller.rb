class SessionsController < ApplicationController
  def create
    session[:user_token] = auth_hash[:credentials][:token]

    flash[:notice] = "Logged in"
    redirect_to root_url
  end

  def destroy
    session[:user_token] = nil

    flash[:notice] = "Logged out"
    redirect_to root_url
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
