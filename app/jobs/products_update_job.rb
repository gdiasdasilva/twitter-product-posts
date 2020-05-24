# frozen_string_literal: true

class ProductsUpdateJob < ActiveJob::Base
  include ActionView::Helpers::NumberHelper

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

    formatted_price = format_currency(product_min_price, currency)

    message = "Check out the most recent news about our #{product_title}.\n" \
              "Now starting at #{formatted_price}." \
              "\n\n" \
              "#{product_url}"

    PostToTwitterService.new(twitter_account: TwitterAccount.first, message: message).call
  end

  private

  def format_currency(value, currency)
    if currency == "USD"
      number_to_currency(value, unit: "$", format: "%u%n")
    else
      number_to_currency(value, unit: "€", format: "%n%u")
    end
  end
end
