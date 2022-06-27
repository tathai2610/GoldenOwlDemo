class ProductImporterJob < ApplicationJob
  queue_as :default

  def perform(products_data, shop_id)
    count = 0
    shop = Shop.find(shop_id)
    products_data.each do |data|
      product = Product.new(name: data[:name], description: data[:description], price: data[:price], quantity: data[:quantity]) 
      data[:categories].each do |c|
        Category.create(name: c) if Category.find_by(name: c).nil?
        product.categories << Category.find_by(name: c)
      end
      data[:images].each.with_index do |i, index|
        image = URI.open(i)
        product.images.attach(io: image, filename: "product_#{product.id}_image_#{index}.jpg")
      end
      product.shop = shop 
      count += 1 if product.save
    end
    puts "Rows of data: #{products_data.size}"
    puts "Products saved: #{count}"
  end
end
