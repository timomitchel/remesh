# frozen_string_literal: true

module Messages
  # Creates a new message for a conversation from the given parameters.
  # Returns a ServiceResult indicating success or failure.
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
