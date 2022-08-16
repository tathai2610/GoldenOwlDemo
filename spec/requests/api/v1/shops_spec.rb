require 'rails_helper'
require 'requests/api/shared_api_context'

RSpec.describe "Api::V1::Shops", type: :request do
  include_context "api context"

  describe "POST #create" do
    subject { post api_v1_shops_path, params: params, headers: headers }

    let(:params) { { shop_registration: {
        "name": "Anniver",
        "description": "Where you can get many great accessories",
        "phone": user_info.phone,
        "city_code": city1.shipping_code,
        "district_code": district1.shipping_code,
        "ward_code": ward1.shipping_code,
        "street_name": "Nobis suscipit perspiciatis"
    } } }

    let(:successful_message) { "You have created your shop. Please wait for an admin to approve." }
    let(:failed_message) { "You already have a shop." }

    context "when user does not have a shop" do
      before { VCR.use_cassette("create_store") { subject } }

      it "returns successful code" do
        expect(response).to have_http_status(200)
      end

      it "returns sucessful message" do
        expect(JSON.parse(response.body)["message"]).to eq(successful_message)
      end

      it "returns created shop" do
        expect(JSON.parse(response.body)).to have_key("data")
      end
    end

    context "when user has already had a shop" do
      let!(:shop) { create(:shop, user: user) }

      before { subject }

      it "returns successful code" do
        expect(response).to have_http_status(200)
      end

      it "returns failed message" do
        expect(JSON.parse(response.body)["message"]).to eq(failed_message)
      end

      it "returns created shop" do
        expect(JSON.parse(response.body)).to have_key("data")
      end
    end
  end
end
