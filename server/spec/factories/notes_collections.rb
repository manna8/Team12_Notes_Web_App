FactoryBot.define do
  factory :notes_collection do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
  end
end
