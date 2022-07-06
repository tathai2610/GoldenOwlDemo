require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.describe "CartItems", type: :request do
  let!(:user) { create(:user) }
  let!(:cart_item) { create(:cart_item, user: user)}

  describe "PUT /update" do
    subject { put cart_item_path(cart_item), params: params, xhr: true }

    let(:params) { { id: cart_item.id, commit: commit } }
    let(:commit) { "inc" }

    context "when user is a guest" do 
      it_behaves_like "successful response"
    end

    describe "when user is a buyer" do
      before { sign_in user }

      context "when user increase quantity" do 
        it_behaves_like "successful response"

        it "increases Cart Item quantity" do 
          expect { subject }.to change { cart_item.reload.quantity }.by(1)
        end
      end 
      
      context "when user decrease quantity" do 
        let(:commit) { "dec" }

        it_behaves_like "successful response"

        it "decreases Cart Item quantity" do 
          expect { subject }.to change { cart_item.reload.quantity }.by(-1)
        end
      end 
    end
  end
end
