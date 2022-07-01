class Admin::DashboardController < ApplicationController
  after_action -> { flash.discard }, if: -> { request.xhr? }
  
  def index
    authorize current_user, policy_class: Admin::DashboardPolicy
  end

  def pending_shops 
    @pending_shops = Shop.where(state: "pending").includes(:user)
    authorize @pending_shops, policy_class: Admin::DashboardPolicy
  end

  def handle_shop
    @shop = Shop.find(params[:shop_id])
    authorize @shop, policy_class: Admin::DashboardPolicy
    respond = handle_open_shop_request(params[:commit], @shop)
    
    respond_to do |format|
      if respond 
        flash[:info] = "#{@shop.user.email}'s #{@shop.name} is now active!"
      else
        flash[:info] = "You have rejected #{@shop.user.email}'s request!"
      end
      format.html { redirect_to admin_shops_pendings_path }
      format.js
    end
  end

  private 

  def handle_open_shop_request(action, shop) 
    if action == "Approve" 
      shop.approve
      shop.user.add_role :seller
      true
    else 
      shop.reject
      false 
    end
  end
end
