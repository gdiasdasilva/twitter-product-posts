# frozen_string_literal: true

class TweetTemplate < ActiveRecord::Base
  validates :template, presence: true

  def example_tweet
    GenerateTweetFromTemplateService.new(
      product_title: "Fortaleza Wooden Sunglasses",
      price: 24.99,
      currency: "EUR",
      product_url: "example.com/fortaleza-wooden-sunglasses",
      template: template
    ).call
  end
end
