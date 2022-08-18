module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :api_authenticate_user, only: :create

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

      def create
        if current_user.has_shop?
          if current_user.shop.active?
            ProductImporterJob.perform_later(products_params["data"], current_user.shop.id)
            render json: { code: 200, message: "Success" }, status: :ok
          else
            render json: { code: 422, message: "Your shop is not active." }, status: :unprocessable_entity
          end
        else
          render json: { code: 422, message: "User does not have a shop. Please register one before adding products!" }, status: :unprocessable_entity
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

      def products_params
        params.require(:products).permit(data: [:name, :description, :price, :quantity, images: [], categories: []])
      end
    end
  end
end
