class RenameBankIdColumnToInvoices < ActiveRecord::Migration
  def change
    rename_column :invoices, :bank_id, :user_bank_id
  end
end
