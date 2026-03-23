require "rails_helper"

RSpec.describe Thought, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:message) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:date_time_sent) }
  end
end
