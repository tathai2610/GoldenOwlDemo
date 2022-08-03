class ShopPolicy < ApplicationPolicy  
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve(shop_owner)
      if user == shop_owner
        scope
      else
        scope.available
      end
    end
  end

  def index? 
    true
  end

  def show?
    return true if record.state == "active" ||  user.shop == record
    false 
  end

  def create? 
    user.present? && (user.shop == nil) && !user.has_role?(:seller)
  end
end
