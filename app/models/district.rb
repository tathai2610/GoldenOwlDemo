class District < ApplicationRecord
  belongs_to :city
  has_many :wards 
  has_many :addresses
end
