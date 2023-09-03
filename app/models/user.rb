class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  #associations
  has_many :addresses, dependent: :destroy
  has_one :primary_address, -> { find_by(is_primary: true) }, class_name: "Address"
end
