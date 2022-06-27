class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :import]
  before_action :check_categories, only: [:create]
  before_action :set_shop, only: [:show, :new, :create, :import]
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
    @product = Product.new(product_params.merge(shop: @shop))
    if @product.save 
      flash[:success] = 'Successfully add a new product!'
      redirect_to shop_product_path(@shop, @product)
    else
      flash[:error] = 'The new product cannot be saved!'
      p @product.errors.full_messages
      render action: :new
    end
  end

  def import
    if params.dig(:products, :file).nil?
      @product = Product.new
      flash[:error] = 'The new product cannot be saved!'
      render action: :new
    else
      ProductsImporterService.call(params[:products][:file], @shop)
      flash[:notice] = "Please wait. Your products will be updated as soon as possible!git "
      redirect_to user_shop_path(@shop.user)
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

  def check_categories
    return if params[:product][:category_ids].size == 1
    params[:product][:category_ids].each do |c| 
      if c.present? && Category.find_by(id: c).nil? 
        new_c = Category.create(name: c)
        c_index = params[:product][:category_ids].find_index(c)
        params[:product][:category_ids][c_index] = new_c.id.to_s
      end
    end
  end
end
