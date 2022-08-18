module Api
  module V1
    class BaseController < ApplicationController
      def api_authenticate_user
        if current_user.blank?
          render json: { code: 401, message: "Please log in to continue" }.to_json, status: :unauthorized
        end
      end

      def current_user
        @current_user ||= User.find_by(jwt: auth_token)
      end

      private

      def auth_token
        @auth_token ||= if request.headers['Authorization'].present?
          request.headers['Authorization'].split(' ').last
        end
      end
    end
  end
end
