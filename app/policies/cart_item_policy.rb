class CartItemPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index? 
    user.present?
  end

  def create? 
    user.present?
  end

  def update? 
    user.present?
  end

  def destroy?
    user.present?
  end

  def destroy_all? 
    user.present?
  end
end
