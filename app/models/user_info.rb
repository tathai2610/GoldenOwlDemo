class UserInfo < ApplicationRecord
  belongs_to :user
  has_many :addresses, as: :addressable
end
