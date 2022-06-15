class Product < ApplicationRecord
  has_one_attached :image
  has_many :category_products, dependent: :destroy 
  has_many :categories, through: :category_products

  # scope :best_sellers, -> { where }
  # 'where' is often used when there are more than one conditions, otherwise 'merge'
  # prefer 'pluck' when select columns, 'map' is used when there are calculations need to be done
  # scope :similar_products, -> id { joins(category_products: :category).where(categories: { id: Product.find(id).categories.pluck(:id) }).where.not(id: id) }
  scope :similar_products, -> id { joins(category_products: :category).merge(Category.where(id: [Product.find(id).categories.pluck(:id)])).where.not(id: id) }
  scope :category, -> name { joins(category_products: :category).merge(Category.where(name: name)) }
end
