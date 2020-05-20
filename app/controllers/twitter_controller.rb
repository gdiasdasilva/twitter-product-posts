# frozen_string_literal: true

# Handle twitter callbacks
class TwitterController < AuthenticatedController
  def oauth_callback

  end

  def request_token
    url_encoded_callback_url = ERB::Util.url_encode(twitter_oauth_callback_url)

    oauth_consumer = OAuth::Consumer.new(
      ENV["TWITTER_API_KEY"],
      ENV["TWITTER_API_SECRET"],
      site: "https://api.twitter.com",
      scheme: :body,
      debug_output: true
    )

    request_token = oauth_consumer.get_request_token(oauth_callback: url_encoded_callback_url)

    session[:token] = request_token.token
    session[:token_secret] = request_token.secret

    redirect_to request_token.authorize_url(oauth_callback: url_encoded_callback_url)
  end
end
