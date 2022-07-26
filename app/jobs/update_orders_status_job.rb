class UpdateOrdersStatusJob < ApplicationJob
  queue_as :default

  def perform(order)
    # get order info from ghn api
    response = GhnClient.new.get_order_info(order.code)
    order_repsonse_status = response["data"]["status"]
    byebug
    # puts "response: " + response["data"]["status"]

    Order::STATUSES.each do |k, v|
      if v.include?(order_repsonse_status.to_sym)
        # update current order status unless new status is the same as current status
        unless k.to_s == order.status_name
          # puts "before: " + order.status
          order.status = k.to_s
          order.save
          # puts "after: " + order.status
        end
        break
      end
    end
  end
end
