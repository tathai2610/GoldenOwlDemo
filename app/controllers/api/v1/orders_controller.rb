module Api
  module V1
    class OrdersController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :api_authenticate_user, only: :create

      def create
        orders = Api::CreateOrdersService.call(order_params, current_user)

        if orders
          result = { code: 201, data: orders }.to_json
          render json: result, status: :created
        else
          head :unprocessable_entity
        end
      end

      private

      def order_params
        params.require(:data).permit(
          user_info: [:name, :phone],
          address: [:street, :ward_code, :district_code, :city_code],
          items: [:name, :shop_id, :quantity])
      end
    end
  end
end
