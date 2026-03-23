class EventLogJob < ApplicationJob
  queue_as :default

  def perform(event_name:, record_type:, record_id:)
    Rails.logger.info(
      "[DomainEvent] #{event_name}: #{record_type}##{record_id} at #{Time.current.iso8601}"
    )
  end
end
