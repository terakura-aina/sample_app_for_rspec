FactoryBot.define do
  factory :task do
    sequence(:title, "test_1")
    status { :todo }
    association :user
  end
end
