class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    #return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :remote_avatar_url)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :remote_avatar_url)
  end
end