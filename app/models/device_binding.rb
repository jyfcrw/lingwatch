# == Schema Information
#
# Table name: device_bindings
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  device_id   :integer
#  device_type :string
#  created_at  :datetime
#  updated_at  :datetime
#

class DeviceBinding < ActiveRecord::Base
  belongs_to :user
  belongs_to :device, polymorphic: true
  alias_attribute :bound_at, :created_at

  scope :bound_at_lt, ->(t) { where('created_at < ?', t.to_datetime) }
  scope :latest, -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :device_id, presence: true, uniqueness: true

end
