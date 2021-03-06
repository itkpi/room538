FactoryGirl.define do
  factory :room do
    name { Faker::Hipster.word }

    trait :with_activities do
      after :create do |room|
        users = create_list :user, 2, room: room
        room_activity = create(:room_activity, room: room)
        users.each.with_index(1) do |user, i|
          create_list(:activity, i, room_activity: room_activity, user: user)
        end
      end
    end
  end
end
