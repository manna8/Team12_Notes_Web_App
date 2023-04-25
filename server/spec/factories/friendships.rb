FactoryBot.define do
  factory :friendship do
    sender_id { FactoryBot.create(:user).id }
    receiver_id { FactoryBot.create(:user).id }
    status { "pending" }

  end
end
