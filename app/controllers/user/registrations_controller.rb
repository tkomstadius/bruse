class User::RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if !resource.own_password
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :default_identity_id, :password, :password_confirmation, :current_password)
  end
end
