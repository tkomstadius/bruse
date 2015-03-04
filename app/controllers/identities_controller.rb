class IdentitiesController < ApplicationController
  def destroy
    identity = Identity.find(params["id"])
    identity.destroy
    redirect_to profile_url
  end
end
