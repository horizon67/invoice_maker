class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :invoices, dependent: :destroy

  validates :name,
    presence: true,
    length: { :maximum => 100 }
  validates :zip_code,
    allow_blank: true,
    format: { with: /\A\d{3}\-?\d{4}\z/ }
  validates :address,
    length: { :maximum => 100 }
  validates :phone_number,
    length: { :maximum => 100 }
  validates :staff_name,
    length: { :maximum => 100 }
  validates :staff_phone_number,
    length: { :maximum => 100 }
end
