class PagesController < ApplicationController
  def show
    render "pages/#{params[:page]}"
  end

  def omniauth_failure
    redirect_to root_url
  end
end
