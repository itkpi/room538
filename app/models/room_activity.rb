# Room activities are activities that room uses
class RoomActivity < ApplicationRecord
  DEFAULT_ROOM_ACTIVITIES = [
    'taking out trash',
    'cleaning room',
    'paying for internet',
    'buying toilet paper',
    'buying trash bags'
  ].freeze

  belongs_to :room
  has_many :activities

  validates :name, presence: true

  scope :enabled, -> { where(enabled: true) }
  default_scope { enabled }

  delegate :users, to: :room

  def user_activities
    @user_activities ||= users.map { |user| UserActivity.new(user: user, room_activity: self) }
  end

  def min_value
    user_activities.map(&:value).min
  end

  def max_value
    user_activities.map(&:value).max
  end

  def next_on_user
    user_activities.find { |user_activity| user_activity.value == min_value }
                   .user
  end

  def enabled?
    enabled
  end
end
