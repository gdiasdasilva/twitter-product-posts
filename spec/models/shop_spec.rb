# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shop, type: :model do
  describe "callbacks" do
    describe "before_create" do
      it "fills tweet_template with the first existing one" do
        tweet_template = create(:tweet_template)
        create(:tweet_template)
        shop = build(:shop, tweet_template: nil)

        expect { shop.save }.to(change { shop.tweet_template })
        expect(shop.tweet_template).to eq tweet_template
      end
    end
  end
end
