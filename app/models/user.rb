class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :shop, dependent: :destroy
  has_one_attached :avatar
  has_many :cart_items, dependent: :destroy

  after_create :attach_avatar

  def cart_items_group_by_shop 
    return nil if cart_items.blank? 

    result = [] 

    cart_items.group_by(&:shop).each { |shop, items| result.push({ shop: shop, items: items })  }

    result
  end

  def cart_total_items 
    return 0 if cart_items.blank? 

    cart_items.sum(&:quantity)
  end

  def cart_total_price
    return 0 if cart_items.blank? 

    cart_items.sum { |i| i.product.price * i.quantity}
  end

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
