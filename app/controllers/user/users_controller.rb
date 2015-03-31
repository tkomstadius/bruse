class User::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def terminate
  end
end
