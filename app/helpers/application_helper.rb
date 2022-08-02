module ApplicationHelper
  include Pagy::Frontend

  def products_section(section, product_id=nil) 
    if section == "similar-products"
      Product.similar_products(product_id).available.limit(4).includes(:shop).with_attached_images
    else
      Product.available.limit(4).includes(:shop).with_attached_images
    end
  end

  def product_categories(product)
    sanitize product.categories.map { |c| "#{link_to c.name, products_path(category: c.name)}".html_safe }.join(", ")
  end

  def flash_class(flash_key)
    case flash_key
    when "notice"
      "info"
    when "info"
      "info"
    when "alert"
      "warning"
    when "error"
      "danger"
    when "success"
      "success"
    when "warning"
      "warning"
    end
  end

  def user_logged_in_and_has_role?(role)
    user_signed_in? && current_user.has_role?(role)
  end

  def svg_tag(path, options={})
    file = File.read(Rails.root.join('app','assets','images',path))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each { |attr, value| svg[attr.to_s] = value }
    
    doc.to_html.html_safe
  end

  def display_price(price)
    number_with_precision(price, precision: 0, delimiter: '.')
  end

  def disable_class(button, cart_item)
    if button == "dec"
      cart_item.quantity == 1 ? "disabled" : ""
    elsif button == "inc"
      cart_item.quantity == cart_item.product.quantity ? "disabled" : ""
    end
  end

  # Check if the item is buy_now_item
  def buy_now?(cart_item)
    return false if @item_buy_now.nil?
    return true if @item_buy_now == cart_item
    false
  end

  def display_status(status) 
    status.gsub('_', ' ').upcase 
  end

  def add_item_to_cart_path(user_signed_in)
    return "/carts/#{current_user.cart.id}/line_items" if user_signed_in
    "/carts/1/line_items"
  end
end
