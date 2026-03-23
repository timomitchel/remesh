# frozen_string_literal: true

# Represents a thought associated with a message.
class Thought < ApplicationRecord
  include Publishable

  belongs_to :message

  validates :text, presence: true
  validates :date_time_sent, presence: true
end
