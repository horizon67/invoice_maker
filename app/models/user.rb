class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :banks, :dependent => :destroy, :class_name => 'UserBank'
  has_many :invoices, :dependent => :destroy
  has_many :customers, :dependent => :destroy

  validates :name,
    presence: true,
    length: { :maximum => 100 }
  validates :zip_code,
    presence: true,
    allow_blank: true,
    format: { with: /\A\d{3}\-?\d{4}\z/ }
  validates :address,
    presence: true,
    length: { :maximum => 100 }
  validates :phone_number,
    presence: true,
    length: { :maximum => 100 }
end
