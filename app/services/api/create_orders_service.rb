module Api
  class CreateOrdersService < ApplicationService
    def initialize(order_params, user)
      @order_params = order_params
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        user_info = UserInfo.find_or_create_by!(@order_params[:user_info].merge(user: @user))
        street = Street.create!(name: @order_params.dig(:address, :street))
        ward = Ward.find_by(shipping_code: @order_params.dig(:address, :ward_code))
        district = District.find_by(shipping_code: @order_params.dig(:address, :district_code))
        city = City.find_by(shipping_code: @order_params.dig(:address, :city_code))
        user_address = Address.create!(
          street: street,
          ward: ward,
          district: district,
          city: city,
          addressable_type: "UserInfo",
          addressable_id: user_info.id
        )

        items = []

        @order_params[:items].each do |item|
          product = Product.find_by(name: item[:name], shop_id: item[:shop_id])
          items << LineItem.create!(line_itemable: @user.cart, product: product, quantity: item[:quantity])
        end

        ordered_items = [].tap do |result|
          items.group_by(&:shop).each { |shop, items| result.push({ shop: shop, items: items }) }
        end

        orders = ::CreateOrdersService.call(ordered_items, user_address, 0)

        payments = [].tap do |payments|
          orders.map do |order|
            payments << { order_id: order.id, created_at: Time.now, updated_at: Time.now }
          end
        end

        Payment.insert_all!(payments)

        orders.each do |order|
          CreateGhnOrderJob.perform_later(order)
        end

        orders
      end
    rescue
      nil
    end
  end
end
