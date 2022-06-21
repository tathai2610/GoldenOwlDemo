require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:categories) { create_list(:category, 3) }
  let(:products) { create_list(:product, 5) }
  before do
    products.first(3).each { |product| product.categories << categories.first } 
    products.last(2).each { |product| product.categories << categories.last } 
  end

  describe "Associations" do 
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:category_products).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:category_products) }
    it { is_expected.to belong_to(:shop).counter_cache(true) }
  end

  describe ".similar_products" do
    it "includes all products with similar categories" do
      subject = Product.similar_products(products.first.id)
      expect(subject).to include(*products[1,2])
    end
  end

  describe ".in_category" do 
    it "include all products with specified category" do 
      subject = Product.in_category(categories.last.name)
      expect(subject).to include(*products.last(2))
    end
  end
end
