class InvoicesController < ApplicationController
  before_action :authenticate_user!

  # GET /invoices
  def index
    @invoices = current_user.invoices.order_default.try(:decorate)
  end

  # GET /invoices/:id
  def show
    @invoice = Invoice.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @invoice
    respond_to do |format|
      format.html
      format.pdf do
        render_invoice_pdf(@invoice) and return
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.details.build
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params).decorate
    @invoice.user = current_user
    unless @invoice.save
      render 'new' and return
    end
    redirect_to invoices_path, flash: {notice: "#{Invoice.model_name.human}を登録しました"}
  end

  # GET /invoices/:id/edit
  def edit
    @invoice = Invoice.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @invoice
  end

  # PATCH /invoices/:id
  def update
    @invoice = Invoice.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @invoice

    unless @invoice.update(invoice_params)
      render 'edit' and return
    end
    redirect_to invoices_path, flash: {notice: "#{Invoice.model_name.human}を更新しました"}
  end

  # DELETE /invoices/:id
  def destroy
    @invoice = Invoice.where(id: params[:id], user: current_user).first.try(:decorate)
    render_404 and return unless @invoice
    @invoice.destroy
    redirect_to invoices_path, flash: {notice: "#{Invoice.model_name.human}を削除しました"}
  end

  private
  def invoice_params
    params.require(:invoice).permit(:customer_id,
                                    :user_bank_id,
                                    :number,
                                    :issue_date,
                                    :payment_deadline,
                                    :including_tax,
                                    :subtotal, :total, :description, details_attributes: [:id, :name, :unit_price, :price, :quantity, :_destroy])
  end

  def render_invoice_pdf(invoice)
    report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'invoice.tlf')
    report.start_new_page

    report.page.item(:customer_name).value(invoice.customer.name)
    report.page.item(:invoice_issue_date).value(invoice.issue_date.strftime("%Y/%m/%d"))
    report.page.item(:invoice_number).value(invoice.number)
    report.page.item(:user_name).value(invoice.user.name)
    report.page.item(:user_zip_code).value(invoice.user.zip_code)
    report.page.item(:user_address).value(invoice.user.address)
    report.page.item(:user_phone_number).value(invoice.user.phone_number)

    report.page.item(:invoice_total).value(ActionController::Base.helpers.number_to_currency(invoice.total))
    report.page.item(:user_bank_name).value(invoice.user_bank.name)
    report.page.item(:user_bank_branch_name).value(invoice.user_bank.branch_name)
    report.page.item(:user_bank_account_type).value(UserBank::ACCOUNT_TYPE_MAP.key(invoice.user_bank.account_type))
    report.page.item(:user_bank_account_number).value(invoice.user_bank.account_number)
    report.page.item(:user_bank_account_name).value(invoice.user_bank.account_name)
    report.page.item(:invoice_description).value(invoice.description)

    invoice.details.each do |detail|
      report.list.add_row do |row|
        row.values invoice_detail_name: detail.name, 
                   invoice_detail_unit_price: ActionController::Base.helpers.number_to_currency(detail.unit_price, unit: ""), 
                   invoice_detail_quantity: detail.quantity, 
                   invoice_detail_price: ActionController::Base.helpers.number_to_currency(detail.price, unit: "")
      end
    end
    report.list do |list|
      list.on_footer_insert do |footer|
        footer.item(:invoice_subtotal).value(ActionController::Base.helpers.number_to_currency(invoice.subtotal))
        tax = invoice.including_tax? ? "込" : ActionController::Base.helpers.number_to_currency(invoice.subtotal * ApplicationSettings.tax_rate / 100)
        footer.item(:tax).value(tax)
        footer.item(:invoice_total).value(ActionController::Base.helpers.number_to_currency(invoice.total))
      end
    end
      
    send_data report.generate, filename: 'invoice.pdf', 
                               type: 'application/pdf', 
                               disposition: 'inline'
  end
end
