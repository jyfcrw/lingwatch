# == Schema Information
#
# Table name: user_agents
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  uid        :string
#  code       :string
#  secret     :string
#  os_type    :string
#  state      :string
#  setting    :hstore
#  created_at :datetime
#  updated_at :datetime
#

class UserAgent < ActiveRecord::Base
  symbolize :state, in: [ :online, :offline ], default: :offline

  belongs_to :user

  validates_presence_of :user, :code, :uid
end
