class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  belongs_to :user_address, class_name: "Address"
  has_many :line_items, as: :line_itemable

  state_machine :status, initial: :created do
    state :created, :preparing, :ready_to_pick, :picking,
          :cancel, :money_collect_picking, :picked,
          :storing, :transporting, :sorting, :delivering, 
          :money_collect_delivering, :delivered, :delivery_fail,
          :waiting_to_return, :return, :return_transporting, :return_sorting,
          :returning, :return_fail, :returned, :exception,
          :damage, :lost, 
          :received, :paid, :completed, :cancelled
  end

  def initialize(status= :created)
    status = status
    super
  end

  def total_price 
    line_items.sum { |item| item.product.price * item.quantity }
  end
end
