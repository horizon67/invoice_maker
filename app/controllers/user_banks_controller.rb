class UserBanksController < ApplicationController
  before_action :authenticate_user!

  # GET /user_banks
  def index
    @user_banks = current_user.banks.order_default.try(:decorate)
  end

  # GET /user_banks/:id
  def show
    @user_bank = UserBank.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @user_bank
  end

  # GET /user_banks/new
  def new
    @user_bank = UserBank.new
  end

  # POST /user_banks
  def create
    @user_bank = UserBank.new(user_bank_params).decorate
    @user_bank.user = current_user
    unless @user_bank.save
      render 'new' and return
    end
    redirect_to user_banks_path, flash: {notice: "#{UserBank.model_name.human}を登録しました"}
  end

  # GET /user_banks/:id/edit
  def edit
    @user_bank = UserBank.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @user_bank
  end

  # PATCH /user_banks/:id
  def update
    @user_bank = UserBank.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @user_bank
    unless @user_bank.update(user_bank_params)
      render 'edit' and return
    end
    redirect_to user_banks_path, flash: {notice: "#{UserBank.model_name.human}を更新しました"}
  end

  private
  def user_bank_params
    params.require(:user_bank).permit(:name,
                                      :account_name,
                                      :account_number,
                                      :account_type,
                                      :branch_name)
  end
end
