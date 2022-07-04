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
    shops = cart_items.pluck(:shop_id).uniq

    shops.each do |s| 
      shop = Shop.find(s)
      items = cart_items.where(user: self, shop: shop).includes(:product)

      result.push({ shop: shop, items: items })
    end

    result
  end

  def cart_total_items 
    return 0 if cart_items.blank? 

    result = 0

    cart_items.each { |i| result += i.quantity }

    result
  end

  def cart_total_price
    return 0 if cart_items.blank? 

    result = 0

    cart_items.each { |i| result += (i.product.price * i.quantity) }

    sprintf("%.2f", result)
  end

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
