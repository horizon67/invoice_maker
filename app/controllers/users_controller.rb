class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def edit
    @user = current_user.decorate
  end

  # PATCH /user
  def update
    @user = current_user.decorate
    unless @user.update(user_params)
      render 'edit' and return
    end
    redirect_to root_path, flash: {notice: "#{User.model_name.human}を更新しました"}
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :zip_code, :address, :phone_number, :signature, :signature_cache)
  end
end
