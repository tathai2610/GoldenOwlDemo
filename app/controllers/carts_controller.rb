class CartsController < ApplicationController
  def show 
    authorize Cart
    @cart = current_user.cart
    @line_items_group_by_shop = @cart.line_items_group_by_shop
    @item_buy_now = LineItem.find(params[:item_buy_now]) if params[:item_buy_now].present?
  end
end
