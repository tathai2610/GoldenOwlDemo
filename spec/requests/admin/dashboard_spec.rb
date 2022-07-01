require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.describe "Admin::Dashboards", type: :request do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let(:shop) { create(:shop, user: user) }

  describe "GET /index" do
    subject { get admin_root_path }

    context "when user is not admin" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is admin" do 
      before { sign_in admin }

      it_behaves_like "successful response"
    end
  end

  describe "GET /pending_shops" do
    subject { get admin_shops_pendings_path }

    context "when user is not admin" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is admin" do 
      before { sign_in admin }

      it_behaves_like "successful response"
    end
  end

  describe "PUT /handle_shop" do
    subject { put admin_handle_shop_path(shop), params: params, xhr: true }

    let(:params) { { commit: commit, shop_id: shop.id } }
    let(:commit) { "Approve" }

    context "when user is not admin" do 
      it_behaves_like "successful response" 

      it "does not change shop's state" do 
        subject
        expect(shop.reload.pending?).to be_truthy
      end

      it "does not update user role" do 
        subject
        expect(user.has_role? :seller).to be_falsy
      end
    end

    describe "when user is admin" do
      before { sign_in admin }

      context "when user approves request" do
        it_behaves_like "successful response"   

        it "updates shop state" do 
          subject 
          expect(shop.reload.active?).to be_truthy
        end
        
        it "updates user role" do 
          subject
          expect(user.has_role? :seller).to be_truthy
        end
      end

      context "when user rejects request" do 
        let(:commit) { "Reject" }

        it_behaves_like "successful response"

        it "does not change shop's state" do 
          subject 
          expect(shop.reload.rejected?).to be_truthy
        end

        it "does not update user role" do 
          subject
          expect(user.has_role? :seller).to be_falsy
        end
      end
    end
  end
end
