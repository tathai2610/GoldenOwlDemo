class ShopRegistrationForm < AddressForm
  attr_accessor :name, :description, :phone, :user, :shop

  validates :name, presence: true
  validates :description, presence: true
  validates :phone, presence: true

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      user.add_role(:seller)
      @shop = Shop.create!(name: name, description: description, phone: phone, user: user)
      shop_address = create_address
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_address
    new_street = Street.create!(name: street_name)
    Address.create!(
      addressable: shop,
      city: City.find_by(shipping_code: city_code),
      district: District.find_by(shipping_code: district_code),
      ward: Ward.find_by(shipping_code: ward_code),
      street: new_street
    )
  end
end
