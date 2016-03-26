class ChangeDatatypeAccountNumberOfUserBanks < ActiveRecord::Migration
  def change
    change_column :user_banks, :account_number, :string
  end
end
