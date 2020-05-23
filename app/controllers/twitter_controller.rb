# frozen_string_literal: true

# Handle twitter callbacks
class TwitterController < AuthenticatedController
  skip_before_action :verify_authenticity_token

  def request_token
    url_encoded_callback_url = ERB::Util.url_encode(twitter_oauth_callback_url)

    request_token = oauth_consumer.get_request_token(oauth_callback: url_encoded_callback_url)

    session[:token] = request_token.token
    session[:token_secret] = request_token.secret

    redirect_to request_token.authorize_url(oauth_callback: url_encoded_callback_url)
  end

  def oauth_callback
    raise "Authentication error." unless params[:oauth_token] == session[:token]

    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret] }

    request_token = OAuth::RequestToken.from_hash(oauth_consumer, hash)
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    twitter_account = TwitterAccount.find_or_create_by!(
      twitter_id: access_token.params[:user_id],
      twitter_handle: access_token.params[:screen_name],
      token: access_token.token,
      secret: access_token.secret
    )

    current_shop.update(twitter_account: twitter_account)
    redirect_to root_path
  end

  def log_out
    current_shop.update(twitter_account: nil)
    redirect_to root_path
  end

  private

  def oauth_consumer
    @oauth_consumer ||= begin
      OAuth::Consumer.new(
        ENV["TWITTER_API_KEY"],
        ENV["TWITTER_API_SECRET"],
        site: "https://api.twitter.com",
        scheme: :body,
        debug_output: true
      )
    end
  end
end
