class Shop::OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve(shop)
      scope.where(shop: shop)
    end
  end

  def index?
    user.present? && user.shop.present?
  end
end
