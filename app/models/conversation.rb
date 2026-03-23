class Conversation < ApplicationRecord
  include Publishable

  has_many :messages, dependent: :destroy

  validates :title, presence: true
  validates :start_date, presence: true

  scope :search_by_title, ->(query) {
    return none if query.blank?
    where("title ILIKE ?", "%#{sanitize_sql_like(query)}%")
  }
end
