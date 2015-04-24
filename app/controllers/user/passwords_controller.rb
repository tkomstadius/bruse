class User::PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, only: [:new, :create, :edit, :update]

  protected
  def after_resetting_password_path_for(resource)
    resource.own_password = true
    resource.save!
    after_sign_in_path_for(resource)
  end
end
