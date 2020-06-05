# frozen_string_literal: true

class ShopsController < AuthenticatedController
  def update
    if params[:tweet_template_id].blank?
      redirect_to tweet_templates_path, alert: "Could not update tweet template. Please try again."
      return
    end

    current_shop.update(tweet_template_id: params[:tweet_template_id])
    redirect_to tweet_templates_path, notice: "Tweet template successfully updated."
  end
end
