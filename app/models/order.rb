class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :line_items, as: :line_itemable

  state_machine :status, initial: :pending do
    # system approves the order
    event :approve do 
      transition pending: :confirmed
    end

    # seller accepts the order after the order is confirmed
    event :prepare do
      transition confirmed: :preparing
    end

    # seller sends the products to shipping department when finish preparing
    event :send do 
      transition preparing: :transporting 
    end

    # buyer receives the order successfully
    event :receive do 
      transition transporting: :received 
    end

    # buyer confirms to pay the order
    event :paid do
      transition received: :paid
    end

    # system closes the orther as completed
    event :close do 
      transition paid: :completed
    end

    # buyer returns the order if it is not correct
    event :return do 
      transition transporting: :returned
    end

    state :pending, :confimed, :preparing, :transporting, :received, 
          :paid, :completed, :returned
  end

  def initialize(status= :pending)
    status = status
    super
  end

  def total_price 
    line_items.sum { |item| item.product.price * item.quantity }
  end
end
