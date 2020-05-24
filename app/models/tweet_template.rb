# frozen_string_literal: true

class TweetTemplate < ActiveRecord::Base
  validates :template, presence: true
end
