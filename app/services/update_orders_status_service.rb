class UpdateOrdersStatusService < ApplicationService
  def call
    Order.on_goings.each do |order|
      UpdateOrdersStatusJob.perform_later(order)
    end
  end
end
