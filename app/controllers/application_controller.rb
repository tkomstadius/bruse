class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # set page layout
  layout :page_layout

  private

  # Find which layout to use, depending on if the user is signed in or not
  #
  # Return layout name
  def page_layout
    if current_user.nil?
      'public/application'
    else
      'application'
    end
  end
end
