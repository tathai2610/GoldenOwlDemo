class CartsController < ApplicationController
  before_action :set_user
  
  def show 
    @cart = @user.cart
    @line_items_group_by_shop = @user.cart.line_items_group_by_shop
  end

  private 

  def set_user 
    @user = User.find(params[:user_id])
  end
end
