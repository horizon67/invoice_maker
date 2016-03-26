class CustomersController < ApplicationController
  before_action :authenticate_user!

  # GET /customers
  def index
    @customers = Customer.where(user: current_user).try(:decorate)
  end

  # GET /customers/new
  def new
    @customer = Customer.new.decorate
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params).decorate
    @customer.user = current_user
    unless @customer.save
      render 'new' and return
    end
    redirect_to customers_path, flash: {notice: "#{Customer.model_name.human}を登録しました"}
  end

  # GET /customers/:id
  def show
    @customer = Customer.find(params[:id]).try(:decorate)
  end

  # GET /customers/:id
  def edit
    @customer = Customer.find(params[:id]).decorate
  end

  # PATCH /customers/:id
  def update
    @customer = Customer.find(params[:id]).decorate
    unless @customer.update(customer_params)
      render 'edit' and return
    end
    redirect_to customers_path, flash: {notice: "#{Customer.model_name.human}を更新しました"}
  end

  # DELETE /customers/:id
  def destroy
    @customer = Customer.find(params[:id]).decorate
    @customer.destroy
    redirect_to customers_path, flash: {notice: "#{Customer.model_name.human}を削除しました"}
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :zip_code, :address, :phone_number, :staff_name, :staff_phone_number)
  end
end
