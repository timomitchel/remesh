FactoryBot.define do
  factory :message do
    conversation
    sequence(:text) { |n| "Message text #{n}" }
    date_time_sent { Time.current }

    trait :with_thoughts do
      after(:create) do |message|
        create_list(:thought, 3, message: message)
      end
    end
  end
end
