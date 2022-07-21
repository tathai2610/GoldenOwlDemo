class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :street
  belongs_to :ward
  belongs_to :district
  belongs_to :city
  has_many :orders

  validates :city, presence: true
  validates :district, presence: true
  validates :ward, presence: true
  validates :street, presence: true

  def to_s
    "#{street.name}, #{ward.name}, #{district.name}, #{city.name}"
  end
end
