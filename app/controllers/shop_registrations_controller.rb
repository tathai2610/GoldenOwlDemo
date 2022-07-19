class ShopRegistrationsController < ApplicationController
  def create
    @shop_registration = ShopRegistrationForm.new(shop_registration_params.merge(user: current_user))

    if @shop_registration.save 
      redirect_to user_shop_path(current_user)
    else 
      render new_user_Shop_path(current_user)
    end
  end

  private 

  def shop_registration_params 
    params.require(:shop_registration_form).permit(:name, :description, :phone, :city, :district, :ward, :street)
  end
end
