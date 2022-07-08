class CartItemsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  def index 
    authorize current_user, policy_class: CartItemPolicy

    @cart_items = current_user.cart_items_group_by_shop
    @item_buy_now = CartItem.find(params[:id]) if params[:id].present?
  end

  def create
    @cart_item = CartItem.find_or_create_by(product: @product, shop: @product.shop)
    authorize @cart_item

    @cart_item.user = current_user
    @cart_item.quantity += cart_item_params[:quantity].to_i
   
    @cart_item.save

    respond_to do |format|
      # format.js { render "create", layout: false, content_type: "text/javascript" }
      format.json { render json: @cart_item }
      format.html { redirect_to cart_items_path(id: @cart_item.id) }
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
    authorize current_user, policy_class: CartItemPolicy
    current_user.cart_items.destroy_all

    respond_to do |format|
      format.html 
      format.js
    end
  end

  private 

  def set_product 
    @product = Product.find(params.dig(:cart_item, :product_id))
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
    authorize @cart_item
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def user_not_authorized
    flash[:warning] = "Please login to access to your shopping cart!"

    redirect_to new_user_session_path
  end
end
