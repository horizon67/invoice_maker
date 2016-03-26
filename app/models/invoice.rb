class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  belongs_to :user_bank
  has_many :details, :dependent => :destroy, :class_name => 'InvoiceDetail'
  accepts_nested_attributes_for :details, allow_destroy: true, reject_if: :all_blank
  before_save :set_subtotal, :set_total
  default_value_for :number do
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  validates :user,
    presence: true
  validates :customer,
    presence: true
  validates :user_bank,
    presence: true
  validates :number,
    presence: true,
    uniqueness: true,
    numericality: { allow_blank: true }
  validates :issue_date,
    presence: true
  validates :description,
    length: { :maximum => 2000 }
  validates :including_tax,
    presence: true,
    allow_blank: true,
    inclusion: { in: [true, false]}
  validate :valid_detail

  private
  def valid_detail
    errors.add(:details, "が入力されていません") if self.details.blank?
  end

  def set_subtotal
    self.subtotal = self.details.inject(0) {|sum, d| sum + (d.unit_price * d.quantity) }
  end

  def set_total
    unless self.including_tax?
      self.total = self.total + (self.subtotal * ApplicationSettings.tax_rate / 100)
    else
      self.total = self.subtotal
    end
  end
end
