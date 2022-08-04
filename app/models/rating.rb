class Rating < ApplicationRecord
  FULL_STAR = 5

  belongs_to :user
  belongs_to :product
  has_many_attached :images

  scope :include_eager_load, -> { includes(user: { avatar_attachment: :blob }).with_attached_images }
end
