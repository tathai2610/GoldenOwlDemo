class RatingsController < ApplicationController
  before_action :set_order, only: :new
  before_action :set_line_item, only: :create
  before_action :set_product, only: :create
  
  def new 
    @line_items = @order.line_items.includes(product: :shop)
  end

  def create 
    @rating = Rating.new(rating_params.merge(user: current_user, product: @product))
    
    if @rating.save 
      @line_item.update(rated: true)
      @error = false 
    else 
      @error = true
    end
  end

  private 

  def set_order
    @order = Order.find(params[:order_id])
    authorize @order, policy_class: RatingPolicy
  end

  def set_line_item
    @line_item = LineItem.find(params[:line_item_id])
    authorize @line_item, policy_class: RatingPolicy
  end

  def set_product 
    @product = Product.find(params[:product_id])
  end

  def rating_params 
    params.require(:rating).permit(:star, :content)
  end
end
