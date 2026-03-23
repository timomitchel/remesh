# frozen_string_literal: true

# Subscribes to domain events published via ActiveSupport::Notifications
# and dispatches asynchronous side effects (e.g., EventLogJob).
# Registered at boot time via config/initializers/domain_events.rb.
module DomainEventSubscriber
  EVENTS = %w[
    conversations.created
    messages.created
    thoughts.created
  ].freeze

  def self.subscribe!
    EVENTS.each do |event_name|
      ActiveSupport::Notifications.subscribe(event_name) do |event|
        record = event.payload[:record]
        EventLogJob.perform_later(
          event_name: event.name,
          record_type: record.class.name,
          record_id: record.id
        )
      end
    end
  end
end
