class UsersController < ApplicationController
  before_action :authenticate_user!

  # Have to put this data in somewhere... doesn't work yet
  # def self.from_omniauth(auth)
  #   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.name = auth.info.name
  #     user.oauth_token = auth.credentials.token
  #     user.oauth_expires_at = Time.at(auth.credentials.expires_at)
  #     user.save!
  #   end
  # end

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
