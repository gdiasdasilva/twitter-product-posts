# frozen_string_literal: true

class ShopsController < AuthenticatedController
  skip_before_action :verify_authenticity_token

  def update
    if params[:tweet_template_id].blank?
      redirect_to root_path, alert: "Could not update tweet template. Please try again."
      return
    end

    current_shop.update(tweet_template_id: params[:tweet_template_id])
    redirect_to root_path, notice: "Tweet template successfully updated."
  end
end
