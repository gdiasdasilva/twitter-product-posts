ShopifyApp.configure do |config|
  config.application_name = "Twitter Product Posts"
  config.api_key = ENV["SHOPIFY_API_KEY"]
  config.secret = ENV["SHOPIFY_API_SECRET"]
  config.old_secret = ""
  config.scope = "read_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2020-04"
  config.shop_session_repository = "Shop"
  config.webhooks = [
    {
      topic: "products/update",
      address: "https://twitter-product-posts.serveo.net/webhooks/products_update",
      format: "json"
    }
  ]
end
