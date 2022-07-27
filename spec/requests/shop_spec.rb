require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.shared_examples "change Shop#count" do |n|
  it "by #{n}" do
    expect { subject }.to change(Shop, :count).by(n)
  end
end

RSpec.describe "Shops", type: :request do
  let(:buyer) { create(:buyer) }
  let!(:seller) { create(:seller) }
  let!(:shop) { create(:shop, user: seller) }

  describe "GET /show" do
    subject { get user_shop_path(seller) } 

    it_behaves_like "successful response"
  end

  describe "GET /new" do 
    subject { get new_user_shop_path(seller) }

    context "when user is guest" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a seller" do 
      before { sign_in seller }

      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a buyer" do 
      before { sign_in buyer }

      subject { get new_user_shop_path(buyer) }

      it_behaves_like "successful response"
    end
  end

  describe "POST /create" do 
    subject { post user_shop_path(seller), params: params }

    let(:params) { { user_id: buyer.id, shop: { name: Faker::Lorem.word.capitalize, 
                                                description: Faker::Lorem.sentence,
                                                phone: "0924150409",
                                                ward: "550110",
                                                district: 1572,
                                                city: 220,
                                                street: "5 anonym" } } }

    context "when user is a guest" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a seller" do 
      before { sign_in seller }

      it_behaves_like "unauthorized redirect response"      
    end

    context "when user is a buyer" do 
      before { sign_in buyer }

      subject { post user_shop_path(buyer), params: params }

      VCR.use_cassette("create store") do
        it_behaves_like "change Shop#count", 1
  
        it "redirects to new shop" do 
          subject
          expect(response).to redirect_to "/users/#{buyer.id}/shop"
        end
  
        it "assigns shop state to pending" do 
          subject 
          expect(Shop.last).to have_attributes(state: "pending")
        end
      end
    end
  end
end
