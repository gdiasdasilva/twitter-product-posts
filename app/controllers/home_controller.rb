# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    set_current_shop

    @twitter_account = @shop.twitter_account
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  private

  def set_current_shop
    @shop = Shop.find_by!(shopify_domain: ShopifyAPI::Shop.current.domain)
  end
end
