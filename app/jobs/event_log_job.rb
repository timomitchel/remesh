# frozen_string_literal: true

# Logs domain events to the Rails logger for observability.
# Enqueued asynchronously by DomainEventSubscriber after
# record creation commits to the database.
class EventLogJob < ApplicationJob
  queue_as :default

  def perform(event_name:, record_type:, record_id:)
    Rails.logger.info(
      "[DomainEvent] #{event_name}: #{record_type}##{record_id} at #{Time.current.iso8601}"
    )
  end
end
