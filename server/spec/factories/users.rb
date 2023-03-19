# FactoryBot.define do
#   factory :user do
#     name { "MyString" }
#     email { "MyString" }
#     password { "MyString" }
#     role { "MyString" }
#   end
# end
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end