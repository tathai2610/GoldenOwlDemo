class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :create_orders, only: [:create, :paypal_create_payment]
  
  def index 
    @orders = OrderPolicy::Scope.new(current_user, Order).resolve.order("created_at DESC")
  end

  def show 
  end

  def new 
    authorize Order
    items = line_items_in(params[:cart_items_ids])
    @line_items_group_by_shop = line_items_group_by_shop(items)
  end

  def create 
    @orders.each do |order|
      response = GhnClient.new.create_order(order)
      raise ActiveRecord::RecordInvalid unless response["code"] == 200
      # Update order code 
      order.update(code: response["data"]["order_code"])
    end

    flash[:success] = "Your order is created"
    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Cannot create your order"
    redirect_back(fallback_location: root_path)
  end

  def paypal_create_payment
    result = PaypalClient.create_payment(orders: @orders)

    if result 
      render json: { token: result }, status: :ok
    else 
      render json: { error: "Payment created failed" }, status: :unprocessable_entity
    end
  end

  def paypal_execute_payment
    if PaypalClient.execute_payment(payment_id: params[:orderID])
      render json: {}, status: :ok
    else 
      render json: { error: "Payment executing failed" }, status: :unprocessable_entity
    end
  end

  def paypal_finish_payment 
    payments = PaypalClient.finish_payment(order_params[:payment_token])  
    flash[:success] = "Your order is created and payment is executed successfully"
    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Cannot create your order"
    redirect_back(fallback_location: root_path)
  end

  private 

  def line_items_group_by_shop(items)
    [].tap do |result|
      items.group_by(&:shop).each { |shop, items| result.push({ shop: shop, items: items }) }
    end
  end

  def line_items_in(item_ids_string)
    [].tap do |items|
      item_ids_string.split(',').each do |p|
        items << LineItem.find(p)
      end
    end
  end
  
  def order_params
    params.require(:order).permit(:cart_items_ids, :user_address_id, :payment_method, :payment_token)
  end
  
  def set_order 
    @order = Order.find(params[:id])
    authorize @order
  end
  
  def create_orders 
    items = line_items_in(order_params[:cart_items_ids])
    line_items_group_by_shop = line_items_group_by_shop(items)
    user_address = Address.find_by(id: order_params[:user_address_id])
    
    @orders ||= CreateOrdersService.call(line_items_group_by_shop, user_address, order_params[:payment_method])
  end
end
