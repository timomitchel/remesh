module Thoughts
  class Creator
    def self.call(message:, params:)
      thought = message.thoughts.new(params)

      if thought.save
        ServiceResult.new(success: true, record: thought)
      else
        ServiceResult.new(success: false, record: thought, errors: thought.errors)
      end
    end
  end
end
