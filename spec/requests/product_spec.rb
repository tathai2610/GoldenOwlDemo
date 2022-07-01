require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.shared_examples "change Product#count" do |n| 
  it "by #{n}" do
    expect { subject }.to change(Product, :count).by(n)
  end
end

RSpec.describe "Products", type: :request do
  let(:buyer) { create(:buyer) }
  let!(:seller) { create(:seller) }
  let!(:shop) { create(:shop, user: seller) }
  let(:product) { create(:product, shop: shop) }

  describe "GET /index" do
    subject { get products_path }

    it_behaves_like "successful response"
  end

  describe "GET /show" do 
    subject { get shop_product_path(shop, product) }

    it_behaves_like "successful response"
  end

  describe "GET /new" do 
    subject { get new_shop_product_path(shop) }

    context "when user is a guest" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a buyer" do 
      before { sign_in buyer }

      it_behaves_like "unauthorized redirect response"
    end

    describe "when user is a seller" do 
      before { sign_in seller }

      context "when shop is pending" do 
        it_behaves_like "unauthorized redirect response"
      end

      context "when shop is active" do 
        before { shop.approve }

        it_behaves_like "successful response"
      end
    end
  end

  describe "POST /create" do 
    subject { post shop_products_path(shop), params: params }

    let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'images', 'default.jpg'), 'image/jpeg') }
    let(:params) { { shop_id: shop.id, product: { name: Faker::Lorem.word, 
      description: "<div>#{Faker::Lorem.paragraphs.join('<br>')}</div>", 
      price: Faker::Number.decimal(l_digits: 2, r_digits: 2), quantity: rand(1..100), 
      category_ids: [""], images: [image] } } }

    context "when user is a guest" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a buyer" do 
      before { sign_in buyer }

      it_behaves_like "unauthorized redirect response"
    end

    describe "when user is a seller" do 
      before { sign_in seller }

      context "when shop is pending" do 
        it_behaves_like "unauthorized redirect response"
      end

      context "when shop is active" do 
        before { shop.approve }

        # add new product and redirect to product show page
        it_behaves_like "redirect response"
        it_behaves_like "change Product#count", 1
      end
    end
  end
end
