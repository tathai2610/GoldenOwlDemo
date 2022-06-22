require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do 
    it { is_expected.to have_one(:shop).dependent(:destroy) }
    it { is_expected.to have_one_attached(:avatar) }
  end
  
  describe "Callbacks" do 
    it { is_expected.to callback(:attach_avatar).after(:create) }
  end

  describe "#attach_avatar" do 
    let (:user) { build(:user) }

    context "when new user is not saved" do 
      it "does not attach avatar" do 
        expect(user.avatar).not_to be_attached
      end
    end

    context "when new user is saved" do 
      it "attached default avatar" do 
        user.save!
        expect(user.avatar).to be_attached
      end
    end
  end
end
