class CreateTweetTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :tweet_templates do |t|
      t.string :template
      t.timestamps
    end
  end
end
