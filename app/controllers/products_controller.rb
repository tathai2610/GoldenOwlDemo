class ProductsController < ApplicationController
  before_action :set_shop, only: [:show, :new, :create]
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

  def new
    @product = Product.new
  end

  def create
    puts product_params
    @product = Product.new(product_params.merge(shop: @shop))
    if @product.save 
      flash[:success] = 'Successfully add a new product!'
      redirect_to shop_product_path(@shop, @product)
    else
      flash[:error] = 'The new product cannot be saved!'
      render action: :new
    end
  end

  private 

  def set_shop 
    @shop = Shop.find(params[:shop_id])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params 
    params.require(:product).permit(:name, :description, :quantity, :price, images: [], category_ids: [])
  end
end
