class ShopPolicy < ApplicationPolicy
  def index? 
    true 
  end

  def show?
    true
  end

  def create? 
    true if user.present? && !user.has_role?(:seller)
  end

  private 
  
  def shop 
    record 
  end
end
