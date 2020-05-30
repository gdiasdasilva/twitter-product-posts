# frozen_string_literal: true

class ShopsController < AuthenticatedController
  skip_before_action :verify_authenticity_token

  def update
    return if params[:tweet_template_id].blank?

    current_shop.update(tweet_template_id: params[:tweet_template_id])
    redirect_to root_path
  end
end
