# frozen_string_literal: true

module Messages
  # Service object that creates a Message and returns a ServiceResult.
  class Creator
    def self.call(conversation:, params:)
      message = conversation.messages.new(params)

      if message.save
        ServiceResult.new(success: true, record: message)
      else
        ServiceResult.new(success: false, record: message, errors: message.errors)
      end
    end
  end
end
