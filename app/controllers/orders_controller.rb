class OrdersController < ApplicationController
  def index 
    @orders = current_user.orders 
  end

  def new 
    @products = []
    params[:products_ids].each do |p|
      @products << Product.find(p.to_i)
    end
  end
end
