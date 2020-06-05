# frozen_string_literal: true

class TweetTemplatesController < AuthenticatedController
  def index
    @active_tweet_template = current_shop.active_tweet_template
    @all_tweet_templates = TweetTemplate.all
  end
end
