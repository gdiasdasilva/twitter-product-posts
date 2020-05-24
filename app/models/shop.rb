# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage

  belongs_to :twitter_account, optional: true

  def api_version
    ShopifyApp.configuration.api_version
  end
end
