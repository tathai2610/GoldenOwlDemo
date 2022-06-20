class ApplicationController < ActionController::Base
  include Pagy::Backend
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up) do |user_params|
  #     user_params.permit(:role, :email, :password, :password_confirmation)
  #   end  
  # end
end
          