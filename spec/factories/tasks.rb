FactoryBot.define do
  factory :task do
    title { "test" }
    status { "todo" }
    association :user
  end
end
