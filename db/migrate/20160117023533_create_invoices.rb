class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user
      t.integer :customer_id
      t.integer :bank_id
      t.string :number
      t.date :issue_date
      t.date :payment_deadline
      t.decimal :subtotal
      t.decimal :total
      t.text :description

      t.timestamps null: false
    end
  end
end
