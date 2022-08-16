module Api
  module V1
    class ShopsController < BaseController
      skip_before_action :verify_authenticity_token

      def create
        if current_user.has_shop?
          render json: { code: 200, message: "You already have a shop." }.to_json, status: :ok
        else
          shop_registration = ShopRegistrationForm.new(shop_registration_params.merge(user: current_user))

          if CreateStoreService.call(shop_registration)
            render json: {
              code: 200,
              message: "You have created your shop. Please wait for an admin to approve.",
              data: current_user.shop
            }.to_json, status: :ok
          else
            render json: { code: 422, message: "Failed to create your shop." }.to_json, status: :unprocessable_entity
          end
        end
      end

      private

      def shop_registration_params
        params.require(:shop_registration).permit(:name, :description, :phone, :city_code, :district_code, :ward_code, :street_name)
      end
    end
  end
end
