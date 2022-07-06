class CartItemsController < ApplicationController
  before_action :set_user, only: [:index, :create, :update, :destroy]
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]
  
  def index 
    @cart_items = @user.cart_items_group_by_shop
    @item_buy_now = CartItem.find(params[:id]) if params[:id].present?
  end

  def create
    @cart_item = CartItem.find_or_create_by(user: @user, product: @product, shop: @product.shop)

    @cart_item.quantity += cart_item_params[:quantity].to_i
    @cart_item.save

    respond_to do |format|
      if params[:add_to_cart]
        # format.js { render "create", layout: false, content_type: "text/javascript" }
        format.json { render json: @cart_item }
      else
        format.html { redirect_to user_cart_items_path(@user, id: @cart_item.id) }
      end
    end
  end

  def update
    @action = params[:commit] if params[:commit]

    if @action == "inc"
      @cart_item.quantity += 1
    elsif @action == "dec"
      @cart_item.quantity -= 1
    end

    @cart_item.save

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy 
    @cart_item.destroy

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def destroy_all 
    current_user.cart_items.destroy_all

    respond_to do |format|
      format.html 
      format.js
    end
  end

  private 

  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_product 
    @product = Product.find(params.dig(:cart_item, :product_id))
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
