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
    user.present? && user.cart_items.include?(record)
  end

  def destroy?
    user.present? && user.cart_items.include?(record)
  end

  def destroy_all? 
    user.present?
  end
end
