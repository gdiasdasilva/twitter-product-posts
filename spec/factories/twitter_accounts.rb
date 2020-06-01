# frozen_string_literal: true

FactoryBot.define do
  factory :twitter_account do
    sequence(:twitter_id) { |n| "twitter-id-#{n}" }
    sequence(:twitter_handle) { |n| "twitter-handle-#{n}" }
    token { "abcdefghijklmnop" }
    secret { "abcdefghijklmnop" }
  end
end
