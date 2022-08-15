require 'rails_helper'
require 'requests/api/shared_api_context'

RSpec.describe "Api::V1:Products", type: :request do
  include_context "api context"

  describe "GET #index" do
    subject { get api_v1_products_path, params: params }

    context "when shop has products" do
      let(:params) { { shop_id: shop.id } }

      it "returns successful response" do
        subject
        expect(response).to have_http_status(200)
      end

      it "returns list of products" do
        subject
        expect(JSON.parse(response.body)["data"]).to be_an_instance_of(Array)
      end
    end

    context "when shop does not have products" do
      let(:params) { { shop_id: 100 } }

      it "returns successful response" do
        subject
        expect(response).to have_http_status(422)
      end

      it "returns empty message" do
        subject
        expect(JSON.parse(response.body)["message"]).to eq("Shop not found")
      end
    end
  end
end
