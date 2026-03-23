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
