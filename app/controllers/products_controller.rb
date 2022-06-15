class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  
  def index 
    @products = Product.all
    if params[:category]
      @products = Product.category(params[:category])
    end
    @pagy, @products = pagy(@products, items: 12)
    @categories = Category.all.order(:name)
  end
  
  def show 
    
  end

  private 

  def set_product
    @product = Product.find(params[:id])
  end
end
