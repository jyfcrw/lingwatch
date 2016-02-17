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
#

class Device < ActiveRecord::Base
  symbolize :state, in: [ :pending, :online, :offline ], default: :pending

  has_one  :binding, class_name: "DeviceBinding"
  has_one  :owner, through: :binding, foreign_key: :owner_id

  has_many :bindings, class_name: "DeviceBinding"
  has_many :owners, through: :bindings, foreign_key: :owner_id

  validates_presence_of :code, :model_type
end
