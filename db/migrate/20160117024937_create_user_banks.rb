class CreateUserBanks < ActiveRecord::Migration
  def change
    create_table :user_banks do |t|
      t.references :user
      t.string :name
      t.string :account_name
      t.integer :account_number
      t.integer :account_type
      t.string :branch_name

      t.timestamps null: false
    end
  end
end
