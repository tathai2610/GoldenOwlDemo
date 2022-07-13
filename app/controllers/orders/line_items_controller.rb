class Orders::LineItemsController < LineItemsController
  before_action :set_line_itemable

  private 

  def set_line_itemable
    @line_itemable = Order.find(params[:order_id])
  end
end
