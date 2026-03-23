FactoryBot.define do
  factory :thought do
    message
    sequence(:text) { |n| "Thought text #{n}" }
    date_time_sent { Time.current }
  end
end
