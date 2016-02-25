# == Schema Information
#
# Table name: dialogues
#
#  id         :integer          not null, primary key
#  device_id  :integer
#  code       :string
#  state      :string
#  setting    :hstore
#  created_at :datetime
#  updated_at :datetime
#

class Dialogue < ActiveRecord::Base
  symbolize :state, in: [ :open, :closed ], default: :open

  belongs_to :device
  has_many   :dialogue_accessions
  has_many   :dialogue_messages

  scope :open, -> { where(state: :open) }

  validates_presence_of :code, :device

  before_validation  :assign_defaults, :on => :create

  after_create :close_other_dialogues

  def full_topic_name
    "Dialogue/#{code}"
  end

  def close_other_dialogues
    Dialogue.where(device: self.device).open.where.not(id: self.id).update_all(state: :closed)
  end

private

  def assign_defaults
    begin
      self.code = rand.to_s[2..7]
    end while self.class.exists?(code: self.code)
  end
end
