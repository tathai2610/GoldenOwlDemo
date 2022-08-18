class UserAddressForm < AddressForm
  attr_accessor :name, :phone, :user, :user_address

  validates :name, presence: true
  validates :phone, presence: true

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      user_info = create_user_info
      @user_address = create_address(user_info)
    end

    true

  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_user_info
    UserInfo.find_or_create_by!(name: name, phone: phone, user: user)
  end

  def create_address(user_info)
    new_street = Street.create!(name: street_name)
    Address.create!(
      addressable: user_info,
      city: City.find_by(shipping_code: city_code),
      district: District.find_by(shipping_code: district_code),
      ward: Ward.find_by(shipping_code: ward_code),
      street: new_street
    )
  end
end
