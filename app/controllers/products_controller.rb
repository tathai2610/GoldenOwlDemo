class ProductsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create, :import]
  before_action :check_categories, only: [:create]
  before_action :set_shop, only: [:show, :new, :create, :import]
  before_action :set_product, only: [:show]
  
  def index
    @products = ProductPolicy::Scope.new(current_user, Product.available).resolve(@user, params[:category]).includes(:shop).with_attached_images
    @pagy, @products = pagy(@products, items: 12)
    @categories = Category.all.order(:name)
  end
  
  def show
    @line_item = LineItem.new

    if !params[:filter_star] || (params[:filter_star] == "All")
      @reviews = @product.ratings.order(created_at: :desc).include_eager_load
    else
      @reviews = @product.send("reviews_#{params[:filter_star]}_star").order(created_at: :desc).include_eager_load 
    end

    @filter = params[:filter_star]
    @pagy, @reviews = pagy(@reviews, items: 6, link_extra: 'data-remote="true"')

    respond_to do |format| 
      format.html 
      format.js { render 'products/ratings/index' } 
    end
  end

  def new
    @product = authorize Product.new(shop: @shop)
  end

  def create
    @product = authorize Product.new(product_params.merge(shop: @shop))
    if @product.save 
      flash[:success] = 'Successfully add a new product!'
      redirect_to shop_product_path(@shop, @product)
    else
      flash[:error] = 'The new product cannot be saved!'
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
    authorize @product
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
