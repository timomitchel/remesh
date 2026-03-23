require "rails_helper"

RSpec.describe Message, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to have_many(:thoughts).order(date_time_sent: :asc).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:date_time_sent) }
  end

  describe "dependent destroy" do
    it "destroys associated thoughts when message is destroyed" do
      message = create(:message, :with_thoughts)
      expect { message.destroy }.to change(Thought, :count).by(-3)
    end
  end
end
