RSpec.shared_context "api context" do
  let(:user) { create(:user) }
  let(:user_info) { create(:user_info, user: user, name: "Tyler", phone: "0924150409") }
  let(:shop) { create(:shop) }
  let(:product) { create(:product, name: "Bottle", shop: shop) }
  let(:city1) { create(:city, shipping_code: 220) }
  let(:city2) { create(:city, shipping_code: 202) }
  let(:district1) { create(:district, shipping_code: 1572, city: city1) }
  let(:district2) { create(:district, shipping_code: 1455, city: city2) }
  let(:ward1) { create(:ward, shipping_code: "550110", district: district1) }
  let(:ward2) { create(:ward, shipping_code: "21414", district: district2) }
  let(:street1) { create(:street, name: "100 30/4" ) }
  let(:street2) { create(:street, name: "100 Cong Hoa" ) }
  let(:user_address) { create(:address, addressabe: user_info, city: city1, district: district1, ward: ward1, street: street1) }
  let(:shop_address) { create(:address, addressabe: shop, city: city2, district: district2, ward: ward2, street: street2) }

  before do
    payload = { user_id: user.id, user_email: user.email }.to_json
    user.update(jwt: JWT.encode(payload, ENV['JWT_KEY'], 'HS256'))
  end
end
