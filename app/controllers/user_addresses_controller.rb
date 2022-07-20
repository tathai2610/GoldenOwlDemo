class UserAddressesController < ApplicationController
  def index 
    @user_addresses = current_user.addresses

    respond_to do |format| 
      format.html 
      format.js
    end
  end

  def show 
    @user_address = Address.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end
  
  def create 
    @user_address = UserAddressForm.new(user_address_params.merge(user: current_user))
    
    @user_address.save
    respond_to do |format| 
      format.js
    end
  end

  private

  def user_address_params 
    params.require(:user_address_form).permit(:name, :phone, :city, :district, :ward, :street)
  end
end
