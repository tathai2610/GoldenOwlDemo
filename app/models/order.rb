class Order < ApplicationRecord
  STATUSES = {
    created:    [:created, :preparing, :ready_to_pick, :picking],
    shipping:   [:picked, :storing, :transporting, :sorting, :delivering, :money_collect_picking],
    received:   [:delivered, :received],
    paid:       [:money_collect_delivering, :paid],
    returned:   [:delivery_fail, :waiting_to_return, :return, :return_transporting, 
                 :return_sorting, :returning, :return_fail, :returned],
    exception:  [:exception, :damage, :lost],
    cancel:     [:cancelled, :cancel],
    completed:  [:completed]
  }

  belongs_to :user
  belongs_to :shop
  belongs_to :user_address, class_name: "Address"
  has_many :line_items, as: :line_itemable

  scope :on_goings, -> { where.not(status: "completed") }

  state_machine :status, initial: :created do
    event 

    state :created, :shipping, :received, :paid, 
          :returned, :exception, :cancel, :completed
  end

  def initialize(status= :created)
    status = status
    super
  end

  def total_price 
    line_items.sum { |item| item.product.price * item.quantity }
  end
end
