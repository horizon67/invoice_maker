class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :banks, :dependent => :destroy, :class_name => 'UserBank'
  has_many :invoices, :dependent => :destroy
  has_many :customers, :dependent => :destroy

  validates :name,
    length: { :maximum => 100 }
  validates :zip_code,
    allow_blank: true,
    format: { with: /\A\d{3}\-?\d{4}\z/ }
  validates :address,
    length: { :maximum => 100 }
  validates :phone_number,
    length: { :maximum => 100 }
end
