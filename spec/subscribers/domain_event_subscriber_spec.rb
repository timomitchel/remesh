require "rails_helper"

RSpec.describe DomainEventSubscriber do
  describe ".subscribe!" do
    it "enqueues EventLogJob when a conversation is created" do
      expect {
        create(:conversation)
      }.to have_enqueued_job(EventLogJob).with(
        event_name: "conversations.created",
        record_type: "Conversation",
        record_id: anything
      )
    end

    it "enqueues EventLogJob when a message is created" do
      expect {
        create(:message)
      }.to have_enqueued_job(EventLogJob).with(
        event_name: "messages.created",
        record_type: "Message",
        record_id: anything
      )
    end

    it "enqueues EventLogJob when a thought is created" do
      expect {
        create(:thought)
      }.to have_enqueued_job(EventLogJob).with(
        event_name: "thoughts.created",
        record_type: "Thought",
        record_id: anything
      )
    end
  end
end
