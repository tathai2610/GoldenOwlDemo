class CartsController < ApplicationController
  before_action :set_user
  
  def show 
    @cart = @user.cart
    @line_items_group_by_shop = @user.cart.line_items_group_by_shop
    @item_buy_now = LineItem.find(params[:item_buy_now]) if params[:item_buy_now].present?
  end

  private 

  def set_user 
    @user = User.find(params[:user_id])
  end
end
