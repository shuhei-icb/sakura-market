module ProductHelper
  def product_image_tag(product, width, height)
    if product.image.attached?
      image_tag product.image.variant(resize_to_fit: [width, height]).processed, alt: "#{product.name}の商品画像", class: 'img-fluid'
    else
      image_tag 'no-image.jpg', size: "#{width}x#{height}", alt: 'no-image', class: 'img-fluid d-block mx-auto'
    end
  end

  def product_published_badge(product)
    status, badge_class =
      if product.published?
        %w[表示中 bg-success]
      else
        %w[非表示 bg-danger]
      end
    content_tag(:span, status, class: "badge #{badge_class}")
  end
end
