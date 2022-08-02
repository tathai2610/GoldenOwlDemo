module URI
  def URI.escape(url)
    URI.encode_www_form_component(url)
  end
end
