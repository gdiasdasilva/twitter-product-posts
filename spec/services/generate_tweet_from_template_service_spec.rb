# frozen_string_literal: true

require "rails_helper"

RSpec.describe GenerateTweetFromTemplateService do
  TEMPLATE = "[product-title] is back for [product-price]. Check it here! [product-url]"

  describe "#call" do
    it "replaces shortcodes by their value correctly" do
      subject = described_class.new(
        product_title: "My product", price: 300.99, currency: "EUR", product_url: "example.org", template: TEMPLATE
      )

      expect(subject.call).to eq "My product is back for 300.99€. Check it here! example.org"
    end

    it "shows $ if currency is USD" do
      subject = described_class.new(
        product_title: "My product", price: 300.99, currency: "USD", product_url: "example.org", template: TEMPLATE
      )

      expect(subject.call).to eq "My product is back for $300.99. Check it here! example.org"
    end

    it "works when template does not include all shortcodes" do
      subject = described_class.new(
        product_title: "Example t-shirt",
        price: 300.99,
        currency: "USD",
        product_url: "example.org",
        template: "[product-title] is amazing"
      )

      expect(subject.call).to eq "Example t-shirt is amazing"
    end
  end
end
