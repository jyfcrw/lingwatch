# == Schema Information
#
# Table name: devices
#
#  id           :integer          not null, primary key
#  code         :string
#  secret       :string
#  model_type   :string
#  name         :string
#  poster       :string
#  mac          :string
#  state        :string
#  setting      :hstore
#  type         :string           not null
#  activated_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  uid          :string
#

class Device < ActiveRecord::Base
  store_accessor :setting, :state_timestamp

  symbolize :state, in: [ :pending, :online, :offline ], default: :pending

  has_one  :binding, class_name: "DeviceBinding"
  has_one  :user, through: :binding, foreign_key: :user_id

  has_many :bindings, class_name: "DeviceBinding"
  has_many :users, through: :bindings, foreign_key: :user_id

  validates_presence_of :code, :model_type

end
