FactoryBot.define do
  factory :conversation do
    sequence(:title) { |n| "Conversation #{n}" }
    start_date { Date.current }

    trait :with_messages do
      after(:create) do |conversation|
        create_list(:message, 3, conversation: conversation)
      end
    end
  end
end
