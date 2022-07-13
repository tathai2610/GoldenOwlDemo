class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, as: :line_itemable

  def line_items_group_by_shop 
    return nil if line_items.blank? 

    [].tap do |result|
      line_items.group_by(&:shop).each { |shop, items| result.push({ shop: shop, items: items }) }
    end
  end
end
