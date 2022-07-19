class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  belongs_to :user_address, class_name: "Address"
  has_many :line_items, as: :line_itemable

  state_machine :status, initial: :created do
    state :created, :preparing, :transporting, :received, 
          :paid, :completed, :cancelled
  end

  def initialize(status= :created)
    status = status
    super
  end

  def total_price 
    line_items.sum { |item| item.product.price * item.quantity }
  end
end
