require 'rails_helper'

RSpec.describe "GhnClient" do 
  let(:user)      { create(:user) }
  let(:user_info) { create(:user_info, user: user) }
  let!(:city)     { create(:city) }
  let!(:district) { create(:district, city: city) }
  let!(:ward)     { create(:ward, district: district) }
  let!(:street)   { create(:street, name: "Nobis suscipit perspiciatis") }
  let!(:city2)        { create(:city, shipping_code: 202) }
  let!(:district2)    { create(:district, city: city2, shipping_code: 1455) }
  let!(:ward2)        { create(:ward, district: district2, shipping_code: "21414") }
  let!(:shop)         { create(:shop) }
  let!(:shop_address) { create(:address, addressable: shop, city: city, district: district, ward: ward, street: street) }
  let(:user_address)  { create(:address, addressable: user_info, city: city2, district: district2, ward: ward2, street: street) }
  let(:product)       { create(:product) }
  
  let(:create_store_response) do 
    VCR.use_cassette("create_store") { GhnClient.new.create_store(shop) } 
  end

  before { shop.update(code: create_store_response["data"]["shop_id"])}

  let(:order)         { create(:order, user: user, shop: shop, user_address: user_address) }
  let!(:line_item)    { create(:line_item, product: product, quantity: 1, line_itemable: order) }

  let(:create_order_response) do
    VCR.use_cassette("create_order") { GhnClient.new.create_order(order) } 
  end

  before { order.update(code: create_order_response["data"]["order_code"])}

  let(:get_order_info_response) do 
    VCR.use_cassette("get_order_info") { GhnClient.new.get_order_info(order.code) }
  end

  describe "GET #create_store" do 
    it "return code 200" do 
      expect(create_store_response["code"]).to eq(200)
    end

    it "contains shop_id" do 
      expect(create_store_response["data"]).to have_key("shop_id")
    end
  end

  describe "POST #create_order" do
    it "return code 200" do 
      expect(create_order_response["code"]).to eq(200)
    end

    it "contains fee" do 
      expect(create_order_response["data"]).to have_key("fee")
    end
  end

  describe "POST #get_order_info" do 
    it "return code 200" do 
      expect(get_order_info_response["code"]).to eq(200)
    end

    it "contains order status" do 
      expect(get_order_info_response["data"]).to have_key("status")
    end
  end

end
