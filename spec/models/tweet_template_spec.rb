# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetTemplate, type: :model do
  describe "#example_tweet" do
    let(:tweet_template) { create(:tweet_template, template: "[product-title] are my favourite") }

    it "returns a dummy message with the current template" do
      expect(tweet_template.example_tweet).to eq "Fortaleza Wooden Sunglasses are my favourite"
    end
  end
end
