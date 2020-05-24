# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_template do
    template { "[product-title] is amazing. I'm glad I bought it for [product-price] at [product-url]." }
  end
end
