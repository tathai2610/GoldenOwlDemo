require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.shared_examples "change Shop#count" do |n|
  it "by #{n}" do
    expect { subject }.to change(Shop, :count).by(n)
  end
end

RSpec.describe "Shops", type: :request do
  let(:buyer) { create(:buyer) }
  let(:seller) { create(:seller) }
  let!(:shop) { create(:shop, user: seller) }

  describe "GET /show" do
    subject { get user_shop_path(seller) }

    it_behaves_like "successful response"
  end

  describe "GET /new" do 
    context "when user is guest" do 
      subject { get new_user_shop_path(buyer) }

      it_behaves_like "unauthenticated response"
    end

    context "when user logs in not as seller" do 
      before { sign_in buyer }

      subject { get new_user_shop_path(buyer) }

      it_behaves_like "successful response"
    end

    context "when user is a seller" do 
      before { sign_in seller }

      subject { get new_user_shop_path(seller) }

      it_behaves_like "redirect response"
    end
  end

  describe "POST /create" do 
    let(:params) { { user_id: buyer.id, shop: { name: Faker::Lorem.word.capitalize, description: Faker::Lorem.sentence } } }

    context "when user is guest" do 
      subject { post user_shop_path(buyer), params: params }

      it_behaves_like "unauthenticated response"
    end

    context "when user logs in not as seller" do 
      before { sign_in buyer }

      subject { post user_shop_path(buyer), params: params }

      it_behaves_like "change Shop#count", 1

      it "redirects to new shop" do 
        subject
        expect(response).to redirect_to "/users/#{buyer.id}/shop"
      end
    end

    context "when user is a seller" do 
      before { sign_in seller }

      subject { post user_shop_path(seller), params: params }

      it_behaves_like "redirect response"
    end
  end
end
