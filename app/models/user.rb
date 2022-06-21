class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :shop, dependent: :destroy
  has_one_attached :avatar

  after_create :attach_avatar

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
