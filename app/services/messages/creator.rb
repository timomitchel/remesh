module Messages
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
