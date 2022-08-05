class RatingPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    user.present? && record.need_rating? && user == record.user  
  end

  def create?
    user.present? && record.need_rating? && user == record.line_itemable.user  
  end
end
