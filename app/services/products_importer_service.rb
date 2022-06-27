require 'csv'
require 'open-uri'

class ProductsImporterService < ApplicationService
  def initialize(file, shop)
    @file = file
    @shop = shop
  end

  def call
    data = []
    CSV.foreach(@file, headers: true) do |row|
      name = row[0]
      description = row[1]
      price = row[2]
      quantity = row[3]
      images = row[4].split(', ')
      categories = row[5].split(', ')

      data.push({ name: name, description: description, price: price, quantity: quantity, images: images, categories: categories })
    end
    ProductImporterJob.perform_later data, @shop.id
  end
end
