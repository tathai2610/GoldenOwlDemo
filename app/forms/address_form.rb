class AddressForm 
  include ActiveModel::Model

  attr_accessor :city, :district, :ward, :street

  validates :city, presence: true
  validates :district, presence: true
  validates :ward, presence: true
  validates :street, presence: true

  def save 
    raise NotImplementedError, "#save must be defined"
  end
end
