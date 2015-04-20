class User::PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, only: [:new, :create, :edit, :update]
  before_filter :require_no_password, only: [:new, :create, :edit, :update]

  protected
  def require_no_password
    if current_user.own_password
      require_no_authentication
    end
  end
end
