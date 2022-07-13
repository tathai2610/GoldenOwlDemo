class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :shop, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_one_attached :avatar
  # has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy

  after_create :attach_avatar
  after_create :create_cart

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end

  def create_cart 
    if cart.nil? 
      Cart.create(user: self)
    end
  end
end
