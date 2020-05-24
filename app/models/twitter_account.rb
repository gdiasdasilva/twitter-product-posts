# frozen_string_literal: true

class TwitterAccount < ActiveRecord::Base
  validates :twitter_id, :twitter_handle, :token, :secret, presence: true
  validates :twitter_id, uniqueness: true
end
