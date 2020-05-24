# frozen_string_literal: true

class CreateTwitterAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :twitter_accounts do |t|
      t.string :twitter_id
      t.string :twitter_handle
      t.string :token
      t.string :secret
      t.timestamps
    end

    add_index :twitter_accounts, :twitter_id, unique: true
  end
end
