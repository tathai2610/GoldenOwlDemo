class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index? 
    true
  end

  def show? 
    true
  end

  def create? 
    user.present? && user.shop == product.shop && user.has_role?(:seller) && user.shop.active?
  end

  private 

  def product 
    record
  end
end
