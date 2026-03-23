class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :title, presence: true
  validates :start_date, presence: true
end
