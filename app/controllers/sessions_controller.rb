class SessionsController < ApplicationController
  def create
    user = {token: auth_hash[:credentials][:token],
            email: auth_hash[:extra][:raw_info][:email],
            name: auth_hash[:extra][:raw_info][:display_name]}
    session[:user] = user

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
