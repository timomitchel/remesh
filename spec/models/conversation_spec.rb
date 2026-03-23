require "rails_helper"

RSpec.describe Conversation, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_date) }
  end

  describe "dependent destroy" do
    it "destroys associated messages when conversation is destroyed" do
      conversation = create(:conversation, :with_messages)
      expect { conversation.destroy }.to change(Message, :count).by(-3)
    end
  end
end
