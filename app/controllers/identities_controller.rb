class IdentitiesController < ApplicationController
  def destroy
    identity = Identity.find(params["id"])
    if identity.user.identities.count > 1
      identity.destroy
      redirect_to profile_url
    else
      user = identity.user
      identity.destroy
      user.destroy
      session[:user_id] = nil
      redirect_to root_url
    end
  end
end
