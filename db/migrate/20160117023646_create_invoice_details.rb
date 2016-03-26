class CreateInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :invoice_details do |t|
      t.references :invoice
      t.string :name
      t.decimal :unit_price
      t.decimal :price
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
