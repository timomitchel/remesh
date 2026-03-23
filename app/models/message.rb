# frozen_string_literal: true

# Represents a message belonging to a conversation, containing thoughts.
class Message < ApplicationRecord
  include Publishable

  belongs_to :conversation
  has_many :thoughts, -> { order(date_time_sent: :asc) }, dependent: :destroy, inverse_of: :message

  validates :text, presence: true
  validates :date_time_sent, presence: true

  scope :search_by_text, lambda { |query|
    return none if query.blank?

    where('text ILIKE ?', "%#{sanitize_sql_like(query)}%")
  }
end
