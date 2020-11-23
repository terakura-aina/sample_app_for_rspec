FactoryBot.define do
  factory :user do
    sequence(:email, "tester_1@example.com")
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
