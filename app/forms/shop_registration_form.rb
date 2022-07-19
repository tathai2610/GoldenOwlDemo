class ShopRegistrationForm < AddressForm
  attr_accessor :name, :description, :phone, :user, :shop, :shop_address

  validates :name, presence: true 
  validates :description, presence: true
  validates :phone, presence: true

  def save 
    return false if invalid?
    @shop = Shop.create(name: name, description: description, phone: phone, user: user)
    @shop_address = create_address
    true
  end

  private 

  def create_address 
    new_street = Street.create(name: street)
    Address.create(addressable: @shop, city: City.find(city), district: District.find(district), ward: Ward.find(ward), street: new_street)
  end
end
