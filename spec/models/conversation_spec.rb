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

  describe ".search_by_title" do
    let!(:matching) { create(:conversation, title: "Team Standup") }
    let!(:non_matching) { create(:conversation, title: "Budget Review") }

    it "returns conversations matching the query (case-insensitive)" do
      results = Conversation.search_by_title("standup")
      expect(results).to include(matching)
      expect(results).not_to include(non_matching)
    end

    it "returns partial matches" do
      expect(Conversation.search_by_title("team")).to include(matching)
    end

    it "returns none for blank query" do
      expect(Conversation.search_by_title("")).to be_empty
      expect(Conversation.search_by_title(nil)).to be_empty
    end

    it "sanitizes % in search input" do
      special = create(:conversation, title: "100% Complete")
      expect(Conversation.search_by_title("100%")).to include(special)
    end

    it "sanitizes _ in search input" do
      special = create(:conversation, title: "file_name_test")
      expect(Conversation.search_by_title("file_n")).to include(special)
    end
  end
end
