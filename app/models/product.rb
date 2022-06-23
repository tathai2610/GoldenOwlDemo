class Product < ApplicationRecord
  has_many_attached :images
  has_many :category_products, dependent: :destroy 
  has_many :categories, through: :category_products
  belongs_to :shop, counter_cache: true

  validates :name, presence: true
  validates :description, presence: true 
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true

  # scope :best_sellers, -> { where }
  # 'where' is often used when there are more than one conditions, otherwise 'merge'
  # prefer 'pluck' when select columns, 'map' is used when there are calculations need to be done
  # scope :similar_products, -> id { joins(category_products: :category).where(categories: { id: Product.find(id).categories.pluck(:id) }).where.not(id: id) }
  scope :similar_products, -> id { joins(category_products: :category).merge(Category.where(id: [Product.find(id).categories.pluck(:id)])).where.not(id: id) }
  scope :in_category, -> name { joins(category_products: :category).merge(Category.where(name: name)) }
end
