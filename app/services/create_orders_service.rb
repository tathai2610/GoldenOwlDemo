class CreateOrdersService < ApplicationService
  def initialize(line_items_group_by_shop, user_address)
    @line_items_group_by_shop = line_items_group_by_shop
    @user_address = user_address
  end

  def call 
    ActiveRecord::Base.transaction do 
      @line_items_group_by_shop.each do |shop_items|
        # Create order for each shop
        order = Order.create!(user: @user_address.addressable.user, 
                              shop: shop_items[:shop], 
                              user_address: @user_address)
        # Calculate total_ptice for each order
        total_price = shop_items[:items].sum { |item| item.product.price * item.quantity }
        
        # Update line_itemable for each LineItem
        LineItem.where(id: shop_items[:items].map(&:id)).update_all(line_itemable_type: "Order", line_itemable_id: order.id) 
        order.update!(total_price: total_price)
        
        # Raise error if API call not success
        raise ActiveRecord::RecordInvalid unless GhnClient.new.create_order(order)
      end
    end
  end
end
