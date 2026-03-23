require "rails_helper"

RSpec.describe Messages::Creator do
  describe ".call" do
    let(:conversation) { create(:conversation) }

    context "with valid params" do
      let(:params) { {text: "Hello world", date_time_sent: Time.current} }

      it "creates a message" do
        expect {
          described_class.call(conversation: conversation, params: params)
        }.to change(Message, :count).by(1)
      end

      it "returns a successful result associated with the conversation" do
        result = described_class.call(conversation: conversation, params: params)
        expect(result).to be_success
        expect(result.record.conversation).to eq(conversation)
      end

      it "publishes a domain event" do
        expect {
          described_class.call(conversation: conversation, params: params)
        }.to have_enqueued_job(EventLogJob).with(
          event_name: "messages.created",
          record_type: "Message",
          record_id: anything
        )
      end
    end

    context "with invalid params" do
      let(:params) { {text: "", date_time_sent: nil} }

      it "does not create a message" do
        expect {
          described_class.call(conversation: conversation, params: params)
        }.not_to change(Message, :count)
      end

      it "returns a failure result with errors" do
        result = described_class.call(conversation: conversation, params: params)
        expect(result).to be_failure
        expect(result.errors).to be_present
      end
    end
  end
end
