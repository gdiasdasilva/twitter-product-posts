# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @twitter_account = current_shop.twitter_account
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
end
