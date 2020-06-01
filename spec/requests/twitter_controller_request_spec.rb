# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TwitterController", type: :request do
  before do
    allow_any_instance_of(AuthenticatedController).to receive(:current_shop).and_return(shop)
    login(shop)
  end

  describe "log_out" do
    let(:shop) { create(:shop, :with_twitter_account) }
    let(:subject) { get "/twitter/log_out" }

    it "removes the twitter account from the shop" do
      expect { subject }.to change { shop.twitter_account_id }.from(shop.twitter_account.id).to(nil)
    end
  end
end
