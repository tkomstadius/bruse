class PagesController < ApplicationController
  def show
    render "pages/#{params[:page]}"
  end

  def omniauth_failure
    flash[:alert] = "Could not link your account. :( Are you sure you gave us permission to do so?"
    if !current_user
      redirect_to root_url
    else
      redirect_to profile_url
    end
  end
end
