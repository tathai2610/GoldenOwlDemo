class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  
  def index 
    @orders = OrderPolicy::Scope.new(current_user, Order).resolve.order("created_at DESC")
  end

  def show 
  end

  def new 
    items = line_items_in(params[:cart_items_ids])
    @line_items_group_by_shop = line_items_group_by_shop(items)
  end

  def create 
    items = line_items_in(order_params[:cart_items_ids])
    line_items_group_by_shop = line_items_group_by_shop(items)
    total_price = 0
    user_address = Address.find_by(id: order_params[:user_address_id])

    line_items_group_by_shop.each do |shop_items|
      o = Order.create(user: current_user, shop: shop_items[:shop], user_address: user_address)
      shop_items[:items].each do |i| 
        i.line_itemable = o
        i.save 
        total_price += (i.product.price * i.quantity)
      end
      o.total_price = total_price
      authorize o 
      o.save
    end

    redirect_to action: :index
  end

  private 

  def line_items_group_by_shop(items)
    [].tap do |result|
      items.group_by(&:shop).each { |shop, items| result.push({ shop: shop, items: items }) }
    end
  end

  def line_items_in(string)
    [].tap do |items|
      string.split(',').each do |p|
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
