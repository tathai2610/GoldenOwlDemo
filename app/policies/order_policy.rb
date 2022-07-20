class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def index? 
    user.present?
  end

  def show?
    user.present? && record.user == user
  end

  def new?
    user.present?
  end

  def create?
    user.present? && record.user == user 
  end
end
