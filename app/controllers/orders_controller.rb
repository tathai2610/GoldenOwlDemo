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
    authorize Order
    items = line_items_in(order_params[:cart_items_ids])
    line_items_group_by_shop = line_items_group_by_shop(items)
    user_address = Address.find_by(id: order_params[:user_address_id])

    CreateOrdersService.call(line_items_group_by_shop, user_address)

    flash[:success] = "Your order is created"
    redirect_to action: :index

  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Cannot create your order"
    redirect_back(fallback_location: root_path)
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
