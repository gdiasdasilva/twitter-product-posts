# frozen_string_literal: true

class AddTweetTemplateToShops < ActiveRecord::Migration[6.0]
  def change
    add_reference :shops, :tweet_template, foreign_key: true
  end
end
