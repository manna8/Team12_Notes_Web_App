FactoryBot.define do
  factory :notes_collection do
    title { "My Notes Collection" }
    description { "A collection of my notes" }
    user
  end
end
