class CreateOrdersService < ApplicationService
  def initialize(line_items_group_by_shop, user_address, payment_method)
    @line_items_group_by_shop = line_items_group_by_shop
    @user_address = user_address
    @payment_method = payment_method
  end

  def call 
    orders = []

    @line_items_group_by_shop.each do |shop_items|
      # Create order for each shop
      order = Order.create(user: @user_address.addressable.user, 
                            shop: shop_items[:shop], 
                            user_address: @user_address,
                            payment_method: @payment_method.to_i)
      # Calculate total_ptice for each order
      total_price = shop_items[:items].sum { |item| item.product.price * item.quantity }
      
      # Update line_itemable for each LineItem
      shop_items[:items].each do |item| 
        # Move the item from cart to order
        item.update(line_itemable: order)
        # Update product quantity when order is created
        item.product.update(quantity: item.product.quantity - item.quantity)
      end

      order.update(total_price: total_price)
      orders.append(order)
    end

    orders = Order.where(id: orders.map(&:id))
  end
end
