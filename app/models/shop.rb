# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage

  belongs_to :twitter_account, optional: true
  belongs_to :tweet_template, optional: true

  alias_attribute :active_tweet_template, :tweet_template

  before_create do
    self.tweet_template = TweetTemplate.first
  end

  def api_version
    ShopifyApp.configuration.api_version
  end
end
