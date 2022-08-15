module Api
  module V1
    class OrdersController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :api_authenticate_user, only: :create
      before_action :set_order, only: :show

      def index
        if current_user
          render json: order_params, status: :ok
        else
          render json: { "error": "error" }, status: :unprocessable_entity
        end
      end

      def show
        render json: @order
      end

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

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:data).permit(
          user_info: [:name, :phone],
          address: [:street, :ward_code, :district_code, :city_code],
          items: [:name, :shop_id, :quantity])
      end
    end
  end
end
