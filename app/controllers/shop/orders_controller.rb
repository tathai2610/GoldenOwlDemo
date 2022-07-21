class Shop::OrdersController < ApplicationController
  before_action :set_shop
  before_action :set_order, only: :show
  
  def index 
    @orders = Shop::OrderPolicy::Scope.new(current_user, Order).resolve(@shop).order(created_at: :desc)
  end

  def show 
    render template: "orders/show"
  end

  private 

  def set_shop 
    @shop = current_user.shop
  end
  
  def set_order 
    @order = Order.find(params[:id])
  end
end

