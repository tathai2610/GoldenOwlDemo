class LineItemsController < ApplicationController
  before_action :set_product, only: :create
  before_action :set_line_item, only: [:update, :destroy]

  def create
    @line_item = LineItem.find_or_initialize_by(product: @product, line_itemable: @line_itemable)
    authorize @line_item

    line_item_quantity = (@line_item.quantity ||= 0) + line_item_params[:quantity].to_i

    if line_item_quantity > @product.quantity
      flash[:error] = "Product quantity is not enough. You want to add total #{line_item_quantity} items but only #{@product.quantity} are available. Please check your cart."
      redirect_back(fallback_location: root_path)
    else
      @line_item.quantity = line_item_quantity
      @line_item.save
      respond_to do |format|
        # format.js { render "create", layout: false, content_type: "text/javascript" }
        format.json { render json: @line_item }
        format.html { redirect_to cart_path(item_buy_now: @line_item.id) }
      end
    end
  end

  def update
    @action = params[:commit] if params[:commit]
    in_stock = @line_item.product.quantity

    if @action == "inc" && in_stock > @line_item.quantity
      @line_item.quantity += 1
    elsif @action == "dec" && @line_item.quantity > 0
      @line_item.quantity -= 1
    else
      @error = true
    end

    @line_item.save

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @line_item.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end

  def set_product
    @product = Product.find(line_item_params[:product_id])
  end

  def set_line_item
    @line_item = LineItem.find(params[:id])
    authorize @line_item
  end
end
