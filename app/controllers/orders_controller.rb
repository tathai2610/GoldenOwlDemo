class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  
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
    items = line_items_in(order_params[:cart_items_ids])
    line_items_group_by_shop = line_items_group_by_shop(items)
    user_address = Address.find_by(id: order_params[:user_address_id])

    ActiveRecord::Base.transaction do 
      line_items_group_by_shop.each do |shop_items|
        order = Order.create!(user: current_user, shop: shop_items[:shop], user_address: user_address)
        total_price = shop_items[:items].sum { |item| item.product.price * item.quantity }
        authorize order
  
        LineItem.where(id: shop_items[:items].map(&:id)).update_all(line_itemable_type: "Order", line_itemable_id: order.id) 
        order.update!(total_price: total_price)
        
        response = GhnClient.new.create_order(order)
      end
    end

    redirect_to action: :index
  end

  private 

  # organize as below: 
  # [
  #   {
  #     shop: <Shop instance>,
  #     items: 
  #     [
  #       <LineItem instance 1>,
  #       <LineItem instance 2>, 
  #       ...
  #     ]
  #   },
  #   {
  #     shop: 
  #     items: []
  #   }
  # ]
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
    params.require(:order).permit(:cart_items_ids, :user_address_id)
  end

  def set_order 
    @order = Order.find(params[:id])
    authorize @order
  end
end
