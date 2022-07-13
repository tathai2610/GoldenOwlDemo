class Shop < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :line_items, through: :products
  has_many :orders, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true 
  validates :description, presence: true

  after_create :attach_avatar

  scope :pendings, -> { where(state: :pending) }

  state_machine :state, initial: :pending do 
    event :approve do 
      transition all => :active
    end

    event :reject do 
      transition pending: :rejected 
    end

    state :active 
    state :pending
    state :rejected
  end

  def initialize(state= :pending)
    state = state
    super
  end

  private

  def attach_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
