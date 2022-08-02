class Product < ApplicationRecord
  belongs_to :shop, counter_cache: true
  has_many :category_products, dependent: :destroy 
  has_many :categories, through: :category_products
  has_many :line_items, dependent: :destroy
  has_many :order_products
  has_many_attached :images
  has_rich_text :description

  validate :description_not_blank
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # scope :best_sellers, -> { where }
  # 'where' is often used when there are more than one conditions, otherwise 'merge'
  # prefer 'pluck' when select columns, 'map' is used when there are calculations need to be done
  # scope :similar_products, -> id { joins(category_products: :category).where(categories: { id: Product.find(id).categories.pluck(:id) }).where.not(id: id) }
  scope :similar_products, -> id { joins(category_products: :category).merge(Category.where(id: [Product.find(id).categories.pluck(:id)])).where.not(id: id) }
  scope :in_category, -> name { joins(category_products: :category).merge(Category.where(name: name)) }
  scope :available, -> { where("quantity > ?", 0).order(created_at: :desc) }

  private 

  def description_not_blank
    errors.add(:description, 'Description is required') if description.blank?
  end
end
