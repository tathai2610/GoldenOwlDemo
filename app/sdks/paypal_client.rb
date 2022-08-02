require 'paypal-checkout-sdk'

class PaypalClient
  def self.create_payment(orders: [])
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

      payments.update_all(status: 1)
      true
    rescue PayPalHttp::HttpError => ioe
      false
    end
  end

  def self.finish_payment(payment_token)
    payments = Payment.where(token: payment_token)
    return nil if payments.blank?
    payments.update_all(status: 2)
    
    payments.each do |payment| 
      CreateGhnOrderJob.perform_later(payment.order)
    end
  end

  def client
    @client ||= PayPal::PayPalHttpClient.new(environment)
  end

  def environment
    @environment ||= PayPal::SandboxEnvironment.new(ENV["PAYPAL_CLIENT_ID"], ENV["PAYPAL_CLIENT_SECRET"])
  end
end
