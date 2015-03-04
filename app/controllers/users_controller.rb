class UsersController < ApplicationController
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
    redirect_to root_url
  end
end
