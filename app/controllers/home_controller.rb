# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @current_shop = current_shop
    @twitter_account = current_shop.twitter_account
    @active_tweet_template = current_shop.active_tweet_template
    @all_tweet_templates = TweetTemplate.all
  end
end
