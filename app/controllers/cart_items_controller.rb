class CartItemsController < ApplicationController
  def index 
    @cart_items = current_user.cart_items_group_by_shop
  end

  def update
    @cart_item = CartItem.find(params[:id])
    action = params[:commit] if params[:commit]

    if action == "dec"
      @cart_item.quantity -= 1
    elsif action == "inc"
      @cart_item.quantity += 1
    end

    @cart_item.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def delete 
    
  end
end
