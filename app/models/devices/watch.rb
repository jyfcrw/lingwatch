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

class Watch < Device
  mount_uploader :poster, PosterUploader

  has_many :dialogues, foreign_key: :device_id

  validates_presence_of :uid
  validates :code, :uid, uniqueness: true

  before_create :assign_defaults

  def available_dialogue
    dialogues.open.last
  end

private
  def assign_defaults
    self.secret = SecureRandom.hex(16)
  end
end
