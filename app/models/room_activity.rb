# Room activities are activities that room uses
class RoomActivity < ApplicationRecord
  belongs_to :room
end