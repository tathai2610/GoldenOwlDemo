module Api 
  module V1 
    class BaseController < ApplicationController      
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
