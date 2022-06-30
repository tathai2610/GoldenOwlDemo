class Admin::DashboardPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index? 
    user.present? && user.has_role?(:admin)
  end

  def pending_shops? 
    index?
  end

  def handle_shop? 
    index?
  end
end
