require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:categories) { create_list(:category, 3) }
  let(:products) { create_list(:product, 5) }
  
  before do
    products.first(3).each { |product| product.categories << categories.first } 
    products.last(2).each { |product| product.categories << categories.last } 
  end

  describe "Associations" do 
    it { is_expected.to have_many_attached(:images) }
    it { is_expected.to have_many(:category_products).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:category_products) }
    it { is_expected.to belong_to(:shop).counter_cache(true) }
    it { is_expected.to have_rich_text(:description) }
  end

  describe "Validations" do 
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:images) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:quantity).only_integer }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

    describe ".description_not_blank" do 
      context "when description is blank" do
        let(:product_no_desct) { build(:product, description: "") }

        it "returns invalid product" do 
          expect(product_no_desct).to_not be_valid
        end
      end
    end
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
