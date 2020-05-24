# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage

  belongs_to :twitter_account, optional: true
  belongs_to :tweet_template, optional: true

  before_create do
    self.tweet_template = TweetTemplate.first
  end

  def api_version
    ShopifyApp.configuration.api_version
  end

  def active_tweet_template
    TweetTemplate.first
  end
end
