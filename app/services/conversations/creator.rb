# frozen_string_literal: true

module Conversations
  # Service object that creates a Conversation and returns a ServiceResult.
  class Creator
    def self.call(params:)
      conversation = Conversation.new(params)

      if conversation.save
        ServiceResult.new(success: true, record: conversation)
      else
        ServiceResult.new(success: false, record: conversation, errors: conversation.errors)
      end
    end
  end
end
