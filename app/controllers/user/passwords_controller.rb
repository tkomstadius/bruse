class User::PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, only: [:new, :create, :edit, :update]
end
