# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  include ShopifyApp::Authenticated

  def current_shop
    @current_shop ||= Shop.find_by!(shopify_domain: ShopifyAPI::Shop.current.domain)
  end
end
