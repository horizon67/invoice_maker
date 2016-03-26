class InvoiceDetail < ActiveRecord::Base
  belongs_to :invice
  before_save :set_price

  validates :name,
    presence: true,
    length: { :maximum => 100 }
  validates :unit_price,
    presence: true,
    numericality: { allow_blank: true }
  validates :quantity,
    presence: true,
    numericality: { allow_blank: true }

  private
  def set_price
    self.price = unit_price * quantity
  end
end
