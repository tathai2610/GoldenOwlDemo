class OrdersController < ApplicationController
  before_action :set_user, only: [:index, :new, :create]
  
  def index 
    @orders = @user.orders 
  end

  def new 
    items = line_items_in(params[:cart_items_ids])
    @line_items_group_by_shop = line_items_group_by_shop(items)
  end

  def create 
    items = line_items_in(order_params[:cart_items_ids])
    line_items_group_by_shop = line_items_group_by_shop(items)
    total_price = 0

    line_items_group_by_shop.each do |shop_items|
      o = Order.create(user: @user, shop: shop_items[:shop])
      shop_items[:items].each do |i| 
        i.line_itemable = o
        i.save 
        total_price += (i.product.price * i.quantity)
      end
      o.total_price = total_price
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
    params.require(:order).permit(:cart_items_ids)
  end

  def set_user 
    @user = User.find(params[:user_id])
  end
end
