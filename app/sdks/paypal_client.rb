require 'paypal-checkout-sdk'

class PaypalClient
  def self.create_payment(orders:)
    # argument 'orders' contains an array of orders
    client = PaypalClient.new.client
    payment_price = ((orders.sum(&:total_price) + (20000 * orders.length)) / 23000).to_s

    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    request.request_body({
      intent: 'CAPTURE',
      purchase_units: [
        {
          amount: {
            currency_code: "USD",
            value: payment_price
          }
        }
      ]
    })

    begin
      response = client.execute(request)
      
      orders.each do |order|
        Payment.create(order: order, token: response.result.id)
      end      

      response.result.id
    rescue PayPalHttp::HttpError => ioe
      false
    end
  end
  
  def self.execute_payment(payment_id:)
    client = PaypalClient.new.client
    payments = Payment.where(token: payment_id)
    return false if payments.nil? 
    payment = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new(payment_id)

    begin 
      response = client.execute(payment)

      payments.each(&:set_executing)
      payments.each(&:save)
      true
    rescue PayPalHttp::HttpError => ioe
      false
    end
  end

  def self.finish_payment(payment_token)
    payments = Payment.where(token: payment_token)
    return nil if payments.blank?
    payments.each do |payment| 
      payment.set_paid
      payment.save 
      
      response = GhnClient.new.create_order(payment.order)
      raise ActiveRecord::RecordInvalid unless response["code"] == 200
      payment.order.update(code: response["data"]["order_code"])
    end
  end

  def client
    @client ||= PayPal::PayPalHttpClient.new(environment)
  end

  def environment
    @environment ||= PayPal::SandboxEnvironment.new(ENV["PAYPAL_CLIENT_ID"], ENV["PAYPAL_CLIENT_SECRET"])
  end
end
