# frozen_string_literal: true

# Handle twitter callbacks
class TwitterController < AuthenticatedController
  def oauth_callback
    raise "different tokens!!!" if params[:oauth_token] != session[:token]

    hash = {
      oauth_token: session[:token],
      oauth_token_secret: session[:token_secret]
    }

    request_token = OAuth::RequestToken.from_hash(oauth_consumer, hash)
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    # access token's oauth token and oauth secret should be persisted for future requests for this user
    # access_token.token
    # access_token.secret

    oauth_params = { consumer: oauth_consumer, token: access_token }

    uri = "https://api.twitter.com/1.1/users/show.json?screen_name="

    hydra = Typhoeus::Hydra.new
    req = Typhoeus::Request.new(uri, method: :get)

    oauth_helper = OAuth::Client::Helper.new(req, oauth_params.merge(request_uri: uri))
    req.options[:headers].merge!("Authorization": oauth_helper.header)

    hydra.queue(req)
    hydra.run

    @response = req.response
  end

  def request_token
    url_encoded_callback_url = ERB::Util.url_encode(twitter_oauth_callback_url)

    request_token = oauth_consumer.get_request_token(oauth_callback: url_encoded_callback_url)

    session[:token] = request_token.token
    session[:token_secret] = request_token.secret

    redirect_to request_token.authorize_url(oauth_callback: url_encoded_callback_url)
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
