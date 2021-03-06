# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_24_232344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.bigint "twitter_account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tweet_template_id"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
    t.index ["tweet_template_id"], name: "index_shops_on_tweet_template_id"
    t.index ["twitter_account_id"], name: "index_shops_on_twitter_account_id"
  end

  create_table "tweet_templates", force: :cascade do |t|
    t.string "template"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "twitter_accounts", force: :cascade do |t|
    t.string "twitter_id"
    t.string "twitter_handle"
    t.string "token"
    t.string "secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["twitter_id"], name: "index_twitter_accounts_on_twitter_id", unique: true
  end

  add_foreign_key "shops", "tweet_templates"
  add_foreign_key "shops", "twitter_accounts"
end
