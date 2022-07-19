class ShopsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_user
  before_action :set_shop, only: [:show]
  before_action :check_shop_exist, only: [:new, :create]

  def show 
    @products = @shop.products 
    @pagy, @products = pagy(@products, items: 12)
  end
  
  def new 
    @shop = ShopRegistrationForm.new
  end

  def create 
    @shop = authorize Shop.new(shop_params.merge(user: @user))
    if @shop.save
      flash[:success] = "Congratulations! You have successfuly open your own shop on Planty!"
      redirect_to user_shop_path(@user)
    else 
      flash[:error] = "Cannot create your shop"
      render root_path
    end
  end

  private 

  def set_user 
    @user = User.find(params[:user_id])
  end

  def set_shop 
    @shop = @user.shop
    authorize @shop
  end

  def shop_params 
    params.require(:shop).permit(:name, :description)
  end

  def check_shop_exist
    if @user.shop.present?
      flash[:error] = "You have already open a shop!"
      redirect_back(fallback_location: root_path)
    end
  end
end
