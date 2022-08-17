module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :verify_authenticity_token

      def index
        if params[:product_id].nil? && params[:product_name].nil? && params[:shop_id].nil?
          render json: { code: 400, message: "Parameter required" }, status: :bad_request
        else
          products = get_products

          if products.present?
            render json: { code: 200, data: products }, status: :ok
          else
            render json: { code: 200, message: "Product not found" }, status: :ok
          end
        end
      end

      private

      def get_products
        if params[:product_id]
          Product.where(id: params[:product_id])
        elsif params[:product_name]
          Product.where(name: params[:product_name])
        elsif params[:shop_id]
          Product.where(shop_id: params[:shop_id])
        end
      end
    end
  end
end
