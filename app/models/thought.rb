class Thought < ApplicationRecord
  include Publishable

  belongs_to :message

  validates :text, presence: true
  validates :date_time_sent, presence: true
end
