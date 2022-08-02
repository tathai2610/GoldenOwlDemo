class CreateGhnOrderJob < ApplicationJob
  queue_as :default

  retry_on ActiveRecord::RecordInvalid

  def perform(order)
    response = GhnClient.new.create_order(order)
    raise ActiveRecord::RecordInvalid unless response["code"] == 200
    order.update(code: response["data"]["order_code"])
  end
end
