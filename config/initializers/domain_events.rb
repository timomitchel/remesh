Rails.application.config.after_initialize do
  DomainEventSubscriber.subscribe!
end
