FactoryBot.define do
  factory :invoice do
    status { Faker::Number.between(from: 0, to: 2) }
    customer_id { create(:customer).id }
    # merchant_id { create(:merchant).id }
  end
end