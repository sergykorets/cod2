class RegistrationsController < Devise::RegistrationsController

  def edit
    @admin = current_user&.admin?
    @info = {
        name: @user.name,
        avatar: @user.avatar.url
    }
    super
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params.except("current_password"))
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :email, :password, :password_confirmation, :remote_avatar_url, :last_name, :company, :specialization, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :email, :avatar, :password, :password_confirmation, :remote_avatar_url, :last_name, :company, :specialization)
  end
end