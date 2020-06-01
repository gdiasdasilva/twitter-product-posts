# frozen_string_literal: true

class GenerateTweetFromTemplateService
  include ActionView::Helpers::NumberHelper

  def initialize(product_title:, price:, currency:, product_url:, template:)
    @product_title = product_title
    @price = price
    @currency = currency
    @product_url = product_url
    @template = template.dup
  end

  def call
    parse_shortcodes
  end

  private

  def parse_shortcodes
    @template.gsub!("[product-title]", @product_title)
    @template.gsub!("[product-price]", formatted_price)
    @template.gsub!("[product-url]", @product_url)
    @template
  end

  def formatted_price
    if @currency == "USD"
      number_to_currency(@price, unit: "$", format: "%u%n")
    else
      number_to_currency(@price, unit: "€", format: "%n%u")
    end
  end
end
