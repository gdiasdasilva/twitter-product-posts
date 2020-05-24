# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TweetTemplate.create(
  template: "Check out the most recent news about our [product-title].\n" \
              "Now starting at [product-price].\n\n[product-url]"
)

TweetTemplate.create(
  template: "They're finally here!\nVisit our store to buy the latest [product-title].\n\n[product-url]"
)

TweetTemplate.create(
  template: "[product-title] is one of our greatest products and we've got some news for you!\n\n"\
              "Check it out at: [product-url]"
)
