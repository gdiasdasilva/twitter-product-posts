# frozen_string_literal: true

FactoryBot.define do
  factory :shop do
    shopify_domain { "example.org" }
    shopify_token  { "abcdefghijk" }
  end
end
