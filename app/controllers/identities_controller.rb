class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    identity = Identity.find(params["id"])
    if identity.user.identities.count > 1
      identity.unlink
      redirect_to profile_url
    else
      redirect_to terminate_user_url
    end
  end
end
