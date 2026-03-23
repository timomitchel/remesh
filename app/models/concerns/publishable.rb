# frozen_string_literal: true

# Publishes a domain event via ActiveSupport::Notifications after a
# record is committed to the database. Included by models that
# participate in the event-driven instrumentation pattern.
module Publishable
  extend ActiveSupport::Concern

  included do
    after_commit :publish_created_event, on: :create
  end

  private

  def publish_created_event
    event_name = "#{self.class.name.underscore.pluralize}.created"
    ActiveSupport::Notifications.instrument(event_name, record: self)
  end
end
