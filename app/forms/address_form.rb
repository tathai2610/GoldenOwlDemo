class AddressForm
  include ActiveModel::Model

  attr_accessor :city_code, :district_code, :ward_code, :street_name

  validates :city_code, presence: true
  validates :district_code, presence: true
  validates :ward_code, presence: true
  validates :street_name, presence: true

  def save
    raise NotImplementedError, "#save must be defined"
  end
end
