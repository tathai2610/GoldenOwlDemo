require 'rails_helper'
require 'requests/shared_examples_for_response'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    subject { get root_path }

    it_behaves_like "successful response"
  end
end
