class Shop < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true 
  validates :description, presence: true

  after_create :attach_avatar

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
