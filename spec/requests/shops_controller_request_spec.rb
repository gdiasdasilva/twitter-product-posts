# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ShopsController", type: :request do
  describe "#update" do
    let(:shop) { create(:shop, tweet_template_id: nil) }
    let(:tweet_template) { create(:tweet_template) }

    let(:subject) { patch "/shops/#{shop.id}", params: { tweet_template_id: tweet_template.id } }

    before do
      login(shop)
      allow_any_instance_of(AuthenticatedController).to receive(:current_shop).and_return(shop)
    end

    it "updates the tweet_template" do
      expect { subject }.to change { shop.active_tweet_template }.from(nil).to(tweet_template)
    end
  end
end
