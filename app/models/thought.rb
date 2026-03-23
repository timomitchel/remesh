class Thought < ApplicationRecord
  belongs_to :message

  validates :text, presence: true
  validates :date_time_sent, presence: true
end
