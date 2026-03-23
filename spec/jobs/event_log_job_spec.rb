# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventLogJob, type: :job do
  describe '#perform' do
    it 'logs the event information' do # rubocop:disable RSpec/ExampleLength
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with( # rubocop:disable RSpec/MessageSpies
        a_string_matching(/\[DomainEvent\] conversations\.created: Conversation#42/)
      )

      described_class.perform_now(
        event_name: 'conversations.created',
        record_type: 'Conversation',
        record_id: 42
      )
    end
  end

  describe 'queue' do
    it 'enqueues on the default queue' do # rubocop:disable RSpec/ExampleLength
      expect do
        described_class.perform_later(
          event_name: 'test.event',
          record_type: 'Test',
          record_id: 1
        )
      end.to have_enqueued_job(described_class).on_queue('default')
    end
  end
end
