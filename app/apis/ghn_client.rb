require 'json'

class GhnClient 
  include HTTParty
  base_uri 'dev-online-gateway.ghn.vn/shiip/public-api'
  headers token: ENV["GHN_API_KEY"]

  def get_province 
    self.class.get('/master-data/province')
  end

  def get_district province_id
    options = { query: { province_id: province_id } }
    self.class.get('/master-data/district', options)
  end

  def get_ward district_id
    options = { query: { district_id: district_id } }
    self.class.get('/master-data/ward', options)
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
      } }
    response = self.class.get("/v2/shop/register", options)
    
    return false if response["code"] != 200
    shop.update(code: response["data"]["shop_id"])
    true
  end

  def create_order(order)
    shop_id = 
  end
end
