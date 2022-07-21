class City < ApplicationRecord
  has_many :districts 
  has_many :addresses 
end
