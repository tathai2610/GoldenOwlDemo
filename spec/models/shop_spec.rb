require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe "Associations" do 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe "Validations" do 
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe "Callbacks" do 
    it { is_expected.to callback(:attach_avatar).after(:create) }
  end

  let(:seller) { create(:seller) }

  describe "#attach_avatar" do 
    let (:shop) { build(:shop, user: seller) }

    context "when new shop is not saved" do 
      it "does not attach avatar" do 
        expect(shop.avatar).not_to be_attached
      end
    end

    context "when new shop is saved" do 
      it "attached default avatar" do 
        shop.save!
        expect(shop.avatar).to be_attached
      end
    end
  end
end
