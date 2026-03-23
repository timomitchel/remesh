require "rails_helper"

RSpec.describe Thoughts::Creator do
  describe ".call" do
    let(:message) { create(:message) }

    context "with valid params" do
      let(:params) { {text: "Great point!", date_time_sent: Time.current} }

      it "creates a thought" do
        expect {
          described_class.call(message: message, params: params)
        }.to change(Thought, :count).by(1)
      end

      it "returns a successful result associated with the message" do
        result = described_class.call(message: message, params: params)
        expect(result).to be_success
        expect(result.record.message).to eq(message)
      end

      it "publishes a domain event" do
        expect {
          described_class.call(message: message, params: params)
        }.to have_enqueued_job(EventLogJob).with(
          event_name: "thoughts.created",
          record_type: "Thought",
          record_id: anything
        )
      end
    end

    context "with invalid params" do
      let(:params) { {text: "", date_time_sent: nil} }

      it "does not create a thought" do
        expect {
          described_class.call(message: message, params: params)
        }.not_to change(Thought, :count)
      end

      it "returns a failure result with errors" do
        result = described_class.call(message: message, params: params)
        expect(result).to be_failure
        expect(result.errors).to be_present
      end
    end
  end
end
