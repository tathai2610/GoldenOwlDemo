require 'json'

class GhnClient 
  include HTTParty
  base_uri 'dev-online-gateway.ghn.vn/shiip/public-api'
  headers token: ENV["GHN_API_KEY"], "Content-Type": "application/json"
  debug_output $stdout

  def get_province 
    self.class.get('/master-data/province')
  end

  def get_district(province_id)
    options = { query: { province_id: province_id } }

    self.class.get('/master-data/district', options)
  end

  def get_ward(district_id)
    options = { query: { district_id: district_id } }

    self.class.get('/master-data/ward', options)
  end

  def get_service(order)
    options = {
      body: {
        shop_id: order.shop.code,
        from_district: order.shop.address.district.shipping_code,
        to_district: order.user_address.district.shipping_code
      }.to_json
    }

    self.class.post('/v2/shipping-order/available-services', options)
  end

  def create_store(shop)
    district_id = shop.address.district.shipping_code
    ward_code = shop.address.ward.shipping_code
    options = { 
      query: {
        district_id: district_id,
        ward_code: ward_code,
        name: shop.name,
        phone: shop.phone,
        address: shop.address.street.name
      } 
    }

    response = self.class.get("/v2/shop/register", options)
    
    return false if response["code"] != 200
    shop.update(code: response["data"]["shop_id"])
    true
  end

  def create_order(order)
    shop_id = order.shop.code.to_s
    to_name = order.user_address.addressable.name
    to_phone = order.user_address.addressable.phone 
    to_address = order.user_address.to_s 
    to_ward_code = order.user_address.ward.shipping_code
    to_district_id = order.user_address.district.shipping_code
    service_response = get_service(order)
    service_id = service_response["data"][0]["service_id"]
    service_type_id = service_response["data"][0]["service_type_id"]
    items = []

    order.line_items.each do |line_item|
      items.push(
        {
          name: line_item.product.name,
          quantity: line_item.quantity,
          weight: 50,
          price: (line_item.product.price * line_item.quantity).to_i
        }
      )
    end
  
    options = {
      headers: { 
        shop_id: shop_id 
      },
      body: {
        to_name: to_name,
        to_phone: to_phone,
        to_address: to_address,
        to_ward_code: to_ward_code,
        to_district_id: to_district_id,
        weight: 200,
        length: 20,
        width: 20,
        height: 10,
        service_id: service_id,
        service_type_id: service_type_id,
        payment_type_id: 2,
        required_note: "CHOTHUHANG",
        items: items
      }.to_json
    }

    response = self.class.post('/v2/shipping-order/create', options)

    return false if response["code"] != 200
    order.update(code: response["data"]["order_code"])
    true
  end

  def get_order_info(order_code) 
    options = {
      body: {
        order_code: order_code
      }.to_json
    }

    self.class.post('/v2/shipping-order/detail', options)
  end
end
