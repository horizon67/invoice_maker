class AddIncludingTaxToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :including_tax, :boolean
  end
end
