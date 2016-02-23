# == Schema Information
#
# Table name: dialogue_accessions
#
#  id          :integer          not null, primary key
#  dialogue_id :integer
#  device_id   :integer
#  action      :string
#  created_at  :datetime
#

class DialogueAccession < ActiveRecord::Base
  symbolize :action, in: [ :in, :out ], default: :in

  belongs_to :device
  belongs_to :dialogue
end
