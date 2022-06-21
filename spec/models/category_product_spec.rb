require 'rails_helper'

RSpec.describe CategoryProduct, type: :model do
  describe "Associations" do 
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:category) }
  end
end
