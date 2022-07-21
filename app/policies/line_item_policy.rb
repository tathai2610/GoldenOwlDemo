class LineItemPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.present? && record.line_itemable == user.cart
  end

  def update?
    create?
  end

  def destroy? 
    create?
  end
end
