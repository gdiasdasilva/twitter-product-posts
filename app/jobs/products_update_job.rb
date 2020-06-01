# frozen_string_literal: true

class ProductsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    if shop.twitter_account.nil?
      logger.error("#{self.class} failed: cannot find twitter account for shop with domain '#{shop_domain}'")
      return
    end

    return unless inventory_stock_returned?(webhook)

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
      template: shop.active_tweet_template.template
    ).call

    PostToTwitterService.new(twitter_account: shop.twitter_account, message: message).call
  end

  private

  def inventory_stock_returned?(webhook)
    webhook[:variants].each do |variant|
      return false unless variant[:old_inventory_quantity].zero?
    end

    webhook[:variants].each do |variant|
      return true if variant[:inventory_quantity].positive?
    end

    false
  end
end
