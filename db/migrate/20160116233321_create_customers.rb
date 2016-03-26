class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :user
      t.string :name,              null: false
      t.string :zip_code
      t.string :address
      t.string :phone_number
      t.string :staff_name
      t.string :staff_phone_number

      t.timestamps null: false
    end
  end
end
