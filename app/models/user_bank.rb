class UserBank < ActiveRecord::Base
  belongs_to :user
  has_many :invoices
  ACCOUNT_TYPE_MAP = {"普通" => 0, "当座" => 1}

  validates :name,
    presence: true,
    length: { :maximum => 100 }
  validates :account_name,
    presence: true,
    length: { :maximum => 100 }
  validates :account_number,
    presence: true,
    numericality: { allow_blank: true }
  validates :account_type,
    presence: true,
    allow_blank: true,
    inclusion: { in: 0..1}
  validates :branch_name,
    presence: true,
    length: { :maximum => 100 }
end
