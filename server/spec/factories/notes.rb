FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    photo { Base64.strict_encode64(Faker::LoremFlickr.image(size: "100x100")) }
    user
  end
end
