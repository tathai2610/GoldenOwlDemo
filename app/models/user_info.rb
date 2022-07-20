class UserInfo < ApplicationRecord
  belongs_to :user
  has_many :addresses, as: :addressable

  validates :name, presence: true 
  validates :phone, presence: true
end
