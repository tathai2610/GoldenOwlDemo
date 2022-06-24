require 'csv'
require 'open-uri'

class ProductsImporterService < ApplicationService
  def initialize(file, shop)
    @file = file
    @shop = shop
  end

  def call
    CSV.foreach(@file, headers: true) do |row|
      name = row[0]
      description = row[1]
      price = row[2]
      quantity = row[3]
      images = row[4].split(', ')
      categories = row[5].split(', ')

      p = Product.new(name: name, description: description, price: price, quantity: quantity)
      categories.each do |c| 
        Category.create(name: c) if Category.find_by(name: c).nil?
        p.categories << Category.find_by(name: c)
      end
      images.each do |i|
        image = URI.open(i)
        p.images.attach(io: image, filename: "product_image.jpg")
      end
      p.shop = @shop 
      p.save
    end
  end
end
