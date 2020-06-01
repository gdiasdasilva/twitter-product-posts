# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductsUpdateJob, type: :job do
  let(:shop) { create(:shop, :with_twitter_account) }
  let(:webhook) { {} }
  let(:shop_domain) { shop.shopify_domain }
  let(:subject) do
    ProductsUpdateJob.new
                     .perform(shop_domain: shop_domain, webhook: webhook)
  end

  before do
    allow(ShopifyAPI::Shop).to receive_message_chain(:current, :currency).and_return("EUR")
    create(:tweet_template)
  end

  describe "shop or twitter account not existing" do
    before do
      expect_any_instance_of(PostToTwitterService).not_to receive(:call)
    end

    context "when shop is not found" do
      let(:shop_domain) { "example.org/not-found-shop" }

      it "returns and calls the logger" do
        expect(Rails.logger).to receive(:error)
          .with("ProductsUpdateJob failed: cannot find shop with domain 'example.org/not-found-shop'")
        subject
      end
    end

    context "when twitter account is nil" do
      let(:shop) { create(:shop) }

      it "returns and calls the logger" do
        expect(Rails.logger).to receive(:error)
          .with("ProductsUpdateJob failed: cannot find twitter account for shop with domain 'example.org'")
        subject
      end
    end
  end

  describe "inventory changes" do
    context "when inventory is 0 and remains 0" do
      let(:webhook) { WEBHOOK_NO_INVENTORY_AVAILABLE }

      it "does not post to twitter" do
        expect_any_instance_of(PostToTwitterService).not_to receive(:call)
        subject
      end
    end

    context "when old inventory was not 0" do
      let(:webhook) { WEBHOOK_ALREADY_WITH_PREVIOUS_INVENTORY }

      it "does not post to twitter" do
        expect_any_instance_of(PostToTwitterService).not_to receive(:call)
        subject
      end
    end

    context "when inventory was 0 for all variants but it is not anymore" do
      let(:webhook) { WEBHOOK_INVENTORY_RETURNED }

      it "posts to twitter" do
        expect_any_instance_of(PostToTwitterService).to receive(:call)
        subject
      end
    end
  end
end

WEBHOOK_NO_INVENTORY_AVAILABLE =
  {
    "title" => "T-shirt SLB1",
    "handle" => "super-t-shirt",
    "variants" => [
      {
        "price" => "9.99",
        "inventory_quantity" => 0,
        "old_inventory_quantity" => 0
      },
      {
        "price" => "15.99",
        "inventory_quantity" => 0,
        "old_inventory_quantity" => 0
      }
    ]
  }.freeze.with_indifferent_access

WEBHOOK_ALREADY_WITH_PREVIOUS_INVENTORY =
  {
    "title" => "T-shirt SLB1",
    "handle" => "super-t-shirt",
    "variants" => [
      {
        "price" => "9.99",
        "inventory_quantity" => 4,
        "old_inventory_quantity" => 5
      },
      {
        "price" => "15.99",
        "inventory_quantity" => 3,
        "old_inventory_quantity" => 0
      }
    ]
  }.freeze.with_indifferent_access

WEBHOOK_INVENTORY_RETURNED =
  {
    "title" => "T-shirt SLB1",
    "handle" => "super-t-shirt",
    "variants" => [
      {
        "price" => "9.99",
        "inventory_quantity" => 5,
        "old_inventory_quantity" => 0
      },
      {
        "price" => "15.99",
        "inventory_quantity" => 0,
        "old_inventory_quantity" => 0
      }
    ]
  }.freeze.with_indifferent_access
