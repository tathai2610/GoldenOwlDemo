class Carts::LineItemsController < LineItemsController
  before_action :set_line_itemable

  def destroy_all
    @line_itemable.line_items.destroy_all

    respond_to do |format|
      format.js
    end
  end

  private 

  def set_line_itemable
    @line_itemable = Cart.find(params[:cart_id])
  end
end
