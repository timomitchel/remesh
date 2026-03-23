# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversations::Creator do
  describe '.call' do
    context 'with valid params' do
      let(:params) { { title: 'Team Discussion', start_date: Date.current } }

      it 'creates a conversation' do
        expect { described_class.call(params: params) }.to change(Conversation, :count).by(1)
      end

      it 'returns a successful result' do # rubocop:disable RSpec/MultipleExpectations
        result = described_class.call(params: params)
        expect(result).to be_success
        expect(result.record).to be_a(Conversation)
        expect(result.record).to be_persisted
      end

      it 'publishes a domain event' do # rubocop:disable RSpec/ExampleLength
        expect do
          described_class.call(params: params)
        end.to have_enqueued_job(EventLogJob).with(
          event_name: 'conversations.created',
          record_type: 'Conversation',
          record_id: anything
        )
      end
    end

    context 'with invalid params' do
      let(:params) { { title: '', start_date: nil } }

      it 'does not create a conversation' do
        expect { described_class.call(params: params) }.not_to change(Conversation, :count)
      end

      it 'returns a failure result with errors' do # rubocop:disable RSpec/MultipleExpectations
        result = described_class.call(params: params)
        expect(result).to be_failure
        expect(result.errors).to be_present
      end
    end
  end
end
