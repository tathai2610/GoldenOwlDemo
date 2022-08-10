module Api 
  module V1 
    class OrdersController < BaseController
      before_action :set_order, only: :create

      def show 
        render json: @order
      end

      def create 
        order = Order.new(order_params)

        if order.save 
          render json: order, status: :created
        else 
          render json: order.errors, status: :unprocessable_entity
        end
      end

      private 

      def set_order 
        @order = Order.find(params[:id])
      end

      def set_user 
        @user = User.find(params[:id])
      end

      def order_params 
        params.require(:order).permit(:user_id, :shop_id)
      end
    end
  end
end
