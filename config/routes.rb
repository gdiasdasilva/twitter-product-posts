Rails.application.routes.draw do
  root to: "home#index"
  mount ShopifyApp::Engine, at: "/"

  namespace :twitter do
    get "request_token"
    get "oauth_callback"
    get "log_out"
  end

  get "faqs", to: "faqs#index"

  resources :shops, only: [:update]
end
