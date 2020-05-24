# frozen_string_literal: true

class ProductsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil? || shop.twitter_account.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    product_url       = "#{shop.shopify_domain}/products/#{webhook[:handle]}"
    product_title     = webhook[:title]
    product_min_price = webhook[:variants].map { |v| v[:price].to_f }.min
    currency          = ""

    shop.with_shopify_session do
      currency = ShopifyAPI::Shop.current.currency
    end

    return unless product_url.present? && product_title.present? && product_min_price.present?

    message = GenerateTweetFromTemplateService.new(
      product_title: product_title,
      price: product_min_price,
      currency: currency,
      product_url: product_url,
      template: shop.current_tweet_template.template
    ).call

    PostToTwitterService.new(twitter_account: TwitterAccount.first, message: message).call
  end
end
