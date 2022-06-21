class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  
  def index 
    unless params[:shop_id]
      @products = Product.all
      @products = Product.in_category(params[:category]) if params[:category]
      @pagy, @products = pagy(@products, items: 12)
      @categories = Category.all.order(:name)
    end
  end
  
  def show
  end

  private 

  def set_product
    @shop = Shop.find(params[:shop_id])
    @product = Product.find(params[:id])
  end
end
