class CartItem < ApplicationRecord
  belongs_to :user 
  belongs_to :product
  # belongs_to :shop
  has_one :shop, through: :product
end
