require 'rails_helper'
require 'requests/api/shared_api_context'

RSpec.shared_examples "successful code" do
  it "returns successful code" do
    subject
    expect(response).to have_http_status(200)
  end
end

RSpec.shared_examples "unprocessable entity code" do
  it "returns unprocessable entity code" do
    subject
    expect(response).to have_http_status(422)
  end
end

RSpec.shared_examples "not found message" do
  it "return not found message" do
    subject
    expect(JSON.parse(response.body)["message"]).to eq(not_found_message)
  end
end

RSpec.describe "Api::V1:Products", type: :request do
  include_context "api context"

  describe "GET #index" do
    subject { get api_v1_products_path, params: params }

    let(:not_found_message) { "Product not found" }

    describe "when user searches products with product_id" do
      context "when the product is found" do
        let(:params) { { product_id: product.id } }

        it_behaves_like "successful code"

        it "returns the product with the same id" do
          subject
          expect(JSON.parse(response.body)["data"][0]["id"]).to eq(product.id)
        end
      end

      context "when no product is found" do
        let(:params) { { product_id: product.id + 1 } }

        it_behaves_like "successful code"
        it_behaves_like "not found message"
      end
    end

    describe "when user searches products with product_name" do
      context "when the products are found" do
        let(:params) { { product_name: product.name } }

        it_behaves_like "successful code"

        it "returns the product(s) with the same name" do
          subject
          expect(JSON.parse(response.body)["data"][0]["name"]).to eq(product.name)
        end
      end

      context "when no product is found" do
        let(:params) { { product_name: Faker::Lorem.sentence.gsub('.', '') } }

        it_behaves_like "successful code"
        it_behaves_like "not found message"
      end
    end

    describe "when user searches products with shop_id" do
      context "when the products are found" do
        let(:params) { { shop_id: shop.id } }

        before { product }

        it_behaves_like "successful code"

        it "returns the product(s) with the same shop" do
          subject
          expect(JSON.parse(response.body)["data"][0]["shop_id"]).to eq(shop.id)
        end
      end

      context "when no product is found" do
        let(:params) { { shop_id: shop.id + 1 } }

        it_behaves_like "successful code"
        it_behaves_like "not found message"
      end
    end

    context "when parameter is missing" do
      let(:params) { {} }

      it "returns bad request code" do
        subject
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "POST #create" do
    subject { post api_v1_products_path, params: params, headers: headers }

    let(:params) { {
      "products": {
        "data": [
          {
            "name": Faker::Lorem.sentence.gsub('.',''),
            "description": "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>",
            "price": 550000,
            "quantity": 26,
            "images": [
              "https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80"
            ],
            "categories": [
            ]
          }
        ]
      }
    } }

    context "when user does not have shop" do
      it_behaves_like "unprocessable entity code"
    end

    describe "when user has shop" do
      let(:user_shop) do
        create(:shop, user: user)
      end

      context "when user's shop is not active" do
        it_behaves_like "unprocessable entity code"
      end

      context "when user's shop is active" do
        before { user_shop.approve }

        it_behaves_like "successful code"
      end
    end

  end
end
