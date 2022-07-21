require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.describe "Carts", type: :request do
  let(:user) { create(:user) }

  describe "GET /show" do
    subject { get cart_path }

    context "when user is a guest" do 
      it_behaves_like "unauthorized redirect response"
    end

    context "when user is a member" do 
      before { sign_in user }

      it_behaves_like "successful response"
    end
  end
end
