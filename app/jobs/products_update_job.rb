class ProductsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    product_handle = webhook[:handle]
    product_url = "#{shop.shopify_domain}/products/#{product_handle}"

    shop.with_shopify_session do
    end
  end
end
