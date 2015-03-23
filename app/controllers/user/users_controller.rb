class User::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def terminate
  end

  def destroy
    user = current_user
    user.identities.each do |id|
      id.destroy
    end
    user.destroy
    session[:user_id] = nil
    flash[:notice] = "Your account is now deleted. We hate to see you go! Remember, you are allways welcome back!"
    redirect_to root_url
  end
end
