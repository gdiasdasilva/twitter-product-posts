# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "bootsnap", ">= 1.4.2", require: false
gem "httparty"
gem "jbuilder", "~> 2.7"
gem "oauth"
gem "pg"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.2", ">= 6.0.2.1"
gem "sass-rails", ">= 6"
gem "shopify_app"
gem "sqlite3", "~> 1.4"
gem "turbolinks", "~> 5"
gem "typhoeus"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "pry-byebug"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end
