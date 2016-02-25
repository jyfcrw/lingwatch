# == Schema Information
#
# Table name: dialogue_messages
#
#  id            :integer          not null, primary key
#  device_id     :integer
#  dialogue_id   :integer
#  device_code   :string
#  dialogue_code :string
#  phone         :string
#  topic         :string
#  content       :string
#  created_at    :datetime
#

class DialogueMessage < ActiveRecord::Base
  belongs_to :device
  belongs_to :dialogue

  before_create :assign_defaults

private
  def assign_defaults
    self.device_code = device.code if device
    self.dialogue_code = dialogue.code if dialogue
    self.phone = device.user.phone if device and device.user
  end
end
