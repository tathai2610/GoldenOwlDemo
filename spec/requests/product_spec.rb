require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.describe "Products", type: :request do
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
end
