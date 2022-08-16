module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :set_shop, only: :index

      def index
        render json: { code: 200, data: @shop.products }.to_json, status: :ok
      end

      def show
        product = Product.find()
      end

      private

      def get_products_with(params)
        @shop = Shop.find(params[:shop_id])
      rescue ActiveRecord::RecordNotFound
        render json: { code: 422, message: "Shop not found" }.to_json, status: :unprocessable_entity
      end
    end
  end
end
