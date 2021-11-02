FactoryBot.define do
  factory :customer, aliases: [:user, :client] do
    name { Faker::Name.name }
    email { Faker::Internet.email }

    transient do
      upcased { false }
    end
    factory :customer_vip do
      vip { true }
      days_to_pay { 30 }
    end
    factory :customer_default do
      vip { false }
      days_to_pay { 10 }
    end
    after(:create) do |customer, evaluator|
      customer.name.upcase! if evaluator.upcased
    end
  end
end