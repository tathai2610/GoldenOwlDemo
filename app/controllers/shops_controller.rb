class ShopsController < ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]
  before_action :check_shop_exist, only: [:new, :create]

  def show 
    @products = @shop.products 
    @pagy, @products = pagy(@products, items: 12)
  end
  
  def new 
    @shop_registration = ShopRegistrationForm.new
  end

  def create 
    @shop_registration = ShopRegistrationForm.new(shop_registration_params.merge(user: @user))

    ActiveRecord::Base.transaction do 
      raise ActiveRecord::RecordInvalid unless (@shop_registration.save && GhnClient.new.create_store(@shop_registration.shop))
      flash[:success] = "Congratulations! You have successfuly open your own shop on Planty!"
      redirect_to user_shop_path(@user)
    end
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Cannot create your shop"
    render :new
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
    params.require(:shop).permit(:name, :description, :phone)
  end

  def shop_registration_params 
    params.require(:shop_registration_form).permit(:name, :description, :phone, :city, :district, :ward, :street)
  end

  def check_shop_exist
    if @user.shop.present?
      flash[:error] = "You have already open a shop!"
      redirect_back(fallback_location: root_path)
    end
  end
end
