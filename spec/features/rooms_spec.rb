RSpec.feature 'Rooms' do
  context 'creation' do
    let(:user) { create(:user) }
    let(:new_activity_name) { 'playing video games' }

    background do
      sign_in user
      visit root_path
    end

    scenario 'User creates new room' do
      click_link 'Create new room'
      fill_in 'Name', with: 'My room'
      click_button 'Create room'
      expect(page).to have_content 'You have successfully created new room "My room".'
      RoomActivity::DEFAULT_ROOM_ACTIVITIES.each do |activity_name|
        expect(page).to have_content activity_name
      end

      fill_in 'Name', with: new_activity_name
      click_button 'Create activity'
      expect(page).to have_content new_activity_name

      click_on 'Continue to Dashboard'
      expect(page).to have_content user.name
      expect(page).to have_content new_activity_name
      RoomActivity::DEFAULT_ROOM_ACTIVITIES.each do |activity_name|
        expect(page).to have_content activity_name
      end
    end
  end

  context 'update' do
    let(:room) { create :room, :with_activities }
    let(:user) { room.users.first }
    let(:new_room_name) { 'New room name' }
    let(:room_activity_name) { room.room_activities.first.name }
    let(:new_room_activity_name) { room.room_activities.first.name }

    background do
      sign_in user
      visit dashboard_path
      click_link 'Room settings'
    end

    scenario 'User updates room' do
      within '.edit_room' do
        fill_in 'Name', with: new_room_name
        click_button 'Update room'
      end

      expect(room.reload.name).to eq new_room_name
      expect(page).to have_content 'You have successfully updated your room'
    end

    scenario 'User changes room activities', js: true do
      uncheck room_activity_name
      expect(room.room_activities.find_by(name: room_activity_name).enabled?).to eq false
    end
  end

  # scenario 'User leaves room' do
  #     user = room.users.first
  #     sign_in user
  #     visit dashboard_path
  #     click_link 'Room settings'
  #
  #     click_button 'Leave room'
  #     within '#leaveRoomModal' do
  #       click_on 'Leave room'
  #     end
  #
  #     user.reload
  #     expect(user.room).to be_nil
  #     expect(Room.where(id: room.id)).to be_empty
  #   end
  #
  #   scenario 'User looks at all rooms' do
  #     rooms = create_list(:room, 3)
  #
  #     within '.page-wrapper' do
  #       click_link 'All rooms'
  #     end
  #
  #     rooms.each do |room|
  #       expect(page).to have_content room.name
  #       room.users.each do |user|
  #         expect(page).to have_content user.name
  #       end
  #     end
  # end
end
