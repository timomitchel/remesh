require "rails_helper"

RSpec.describe EventLogJob, type: :job do
  describe "#perform" do
    it "logs the event information" do
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with(
        a_string_matching(/\[DomainEvent\] conversations\.created: Conversation#42/)
      )

      described_class.perform_now(
        event_name: "conversations.created",
        record_type: "Conversation",
        record_id: 42
      )
    end
  end

  describe "queue" do
    it "enqueues on the default queue" do
      expect {
        described_class.perform_later(
          event_name: "test.event",
          record_type: "Test",
          record_id: 1
        )
      }.to have_enqueued_job(described_class).on_queue("default")
    end
  end
end
