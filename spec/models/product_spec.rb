require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Associations" do 
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:category_products).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:category_products) }
    it { is_expected.to belong_to(:shop).counter_cache(true) }
  end
end
