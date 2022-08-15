class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :clear_xhr_flash

  def clear_xhr_flash
    flash.discard if request.xhr?
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}",
      scope: "pundit",
      default: :default
    redirect_back(fallback_location: root_path)
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.has_role? :admin
    super
  end
end
