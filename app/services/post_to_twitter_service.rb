# frozen_string_literal: true

require "oauth/request_proxy/typhoeus_request"

class PostToTwitterService
  UPDATE_ENDPOINT_URL = "https://api.twitter.com/1.1/statuses/update.json"

  def initialize(twitter_account:, message:)
    @twitter_account = twitter_account
    @message = message
  end

  def call
    oauth_params = {
      consumer: oauth_consumer,
      token: OAuth::AccessToken.new(oauth_consumer, @twitter_account.token, @twitter_account.secret)
    }

    req = Typhoeus::Request.new(UPDATE_ENDPOINT_URL, method: :post, params: { status: @message })
    oauth_helper = OAuth::Client::Helper.new(req, oauth_params.merge(request_uri: UPDATE_ENDPOINT_URL))

    req.options[:headers].merge!("Authorization": oauth_helper.header)
    req.run

    req.response
  end

  private

  def oauth_consumer
    @oauth_consumer ||= begin
      OAuth::Consumer.new(
        ENV["TWITTER_API_KEY"],
        ENV["TWITTER_API_SECRET"],
        site: "https://api.twitter.com",
        scheme: :body
      )
    end
  end
end
