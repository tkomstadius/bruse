class PagesController < ApplicationController
  def show
    render "pages/#{params[:page]}"
  end

  def omniauth_failure
    flash[:alert] = "Could not link your account. :( Are you sure you gave us permission to do so?"
    redirect_to root_url
  end
end
