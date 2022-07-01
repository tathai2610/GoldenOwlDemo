module ApplicationHelper
  include Pagy::Frontend

  def products_section(section, product_id=nil) 
    if section == "similar-products"
      Product.similar_products(product_id).first(4)
    else
      Product.first(4)
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
    end
  end

  def user_has_role?(role)
    user_signed_in? && current_user.has_role?(role)
  end
end
