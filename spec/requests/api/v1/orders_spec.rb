require 'rails_helper'
require 'requests/api/shared_api_context'

RSpec.describe "Api::V1::Orders", type: :request do
  include_context "api context"

  describe 'POST #create' do
    subject { post api_v1_orders_path, params: params, headers: headers }

    let(:create_orders_response) do
      VCR.use_cassette("api_create_store") { subject }
    end

    context "when params are valid" do
      let(:params) do
        {
          data: {
            user_info: {
              name: user_info.name,
              phone: user_info.phone
            },
            address: {
              street: street1.name,
              ward_code: ward1.shipping_code,
              district_code: district1.shipping_code,
              city_code: city1.shipping_code,
            },
            items: [
              {
                name: product.name,
                shop_id: shop.id,
                quantity: 1
              }
            ]
          }
        }
      end

      it "returns successful code" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "returns orders data" do
        subject
        expect(JSON.parse(response.body)["data"][0]).to have_key("id")
      end
    end

    context "when params are not valid" do
      let(:params) do
        {
          data: {
            user_info: {
              name: user_info.name,
              phone: user_info.phone
            },
            address: {
              street: street1.name,
              ward_code: ward1.shipping_code,
              district_code: district1.shipping_code,
              city_code: city1.shipping_code,
            },
            items: [
              {
                name: product.name,
                shop_id: 100,
                quantity: 1
              }
            ]
          }
        }
      end

      it "returns failed code" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
