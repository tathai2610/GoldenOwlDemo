class LineItem < ApplicationRecord
  belongs_to :line_itemable, polymorphic: true
  belongs_to :product
  belongs_to :shop
  delegate :shop, to: :product

  def need_rating?
    true unless rated?
  end
end
