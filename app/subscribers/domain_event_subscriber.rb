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
