# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwitterAccount, type: :model do
  describe "validations" do
    it "does not allow repeated twitter_ids" do
      create(:twitter_account, twitter_id: "abcdefgh")

      twitter_account = build(:twitter_account, twitter_id: "abcdefgh")
      expect(twitter_account).to be_invalid
    end
  end
end
