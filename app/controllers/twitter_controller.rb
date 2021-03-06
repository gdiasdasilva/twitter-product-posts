# frozen_string_literal: true

class TwitterController < AuthenticatedController
  def request_token
    begin
      url_encoded_callback_url = ERB::Util.url_encode(twitter_oauth_callback_url)
      request_token = oauth_consumer.get_request_token(oauth_callback: url_encoded_callback_url)
    rescue OAuth::Unauthorized
      redirect_to root_path, alert: "Could not connect to Twitter. Please try again."
      return
    end

    session[:token] = request_token.token
    session[:token_secret] = request_token.secret

    redirect_to request_token.authorize_url(oauth_callback: url_encoded_callback_url)
  end

  def oauth_callback
    unless params[:oauth_token] == session[:token]
      redirect_to root_path, alert: "Invalid OAuth token. Please try again."
      return
    end

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
    redirect_to root_path, notice: "Your Twitter account was successfully linked."
  end

  def log_out
    current_shop.update(twitter_account: nil)
    redirect_to root_path, notice: "Twitter account successfully unlinked."
  end

  private

  def oauth_consumer
    @oauth_consumer ||= begin
      OAuth::Consumer.new(
        ENV["TWITTER_API_KEY"],
        ENV["TWITTER_API_SECRET"],
        site: "https://api.twitter.com",
        scheme: :body,
      )
    end
  end
end
