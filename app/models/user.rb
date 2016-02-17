# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  phone               :string
#  avatar              :string
#  unconfirmed_phone   :string
#  created_at          :datetime
#  updated_at          :datetime
#  extra               :text
#  sms_confirmed_at    :datetime
#  crypted_password    :string
#  password_salt       :string
#  persistence_token   :string
#  single_access_token :string
#  perishable_token    :string
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string
#  last_login_ip       :string
#  active              :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  apply_simple_captcha

  acts_as_authentic do |c|
    c.login_field = :phone

    c.merge_validates_format_of_login_field_options                  if: :registered?
    c.merge_validates_length_of_login_field_options                  if: :registered?
    c.merge_validates_confirmation_of_password_field_options         if: :registered?
  end

  typed_store :extra do |s|
    s.datetime :sms_last_request_at
    s.string   :sms_confirmation_code
  end

  has_many :device_bindings
  has_many :devices, through: :device_bindings

  # For example
  has_many :simple_devices, through: :device_bindings, source: :device , source_type: "SimpleDevice"

  mount_uploader :avatar, AvatarUploader

  scope :registered, -> { where("sms_confirmed_at IS NOT NULL AND phone IS NOT NULL") }
  scope :unregistered, -> { where("sms_confirmed_at IS NULL AND phone IS NULL") }

  validates :name, length: { minimum: 2, maximum: 10 }, allow_nil: true
  validates :phone, format: { with: /\A[0-9]{11}\z/ }, allow_nil: true
  validates :unconfirmed_phone, format: { with: /\A[0-9]{11}\z/ }, allow_nil: true

  before_validation :assign_defaults

  def registered?
    self.phone.present? && self.sms_confirmed_at.present?
  end

  def is_sms_confirmation_code_expired?
    return self.sms_last_request_at && self.sms_last_request_at + Project.sms_expired_duration < Time.now
  end

  def can_sent_sms_confirmation?
    return !(self.sms_last_request_at && self.sms_last_request_at + Project.sms_resend_interval > Time.now)
  end

  def send_sms_confirmation_instructions_to_unconfirmed_phone
    return false unless self.unconfirmed_phone.present? and self.can_sent_sms_confirmation?
    send_sms_confirmation(self.unconfirmed_phone)
  end

  def send_sms_confirmation_instructions
    return false unless self.phone.present? and self.can_sent_sms_confirmation?
    send_sms_confirmation(self.phone)
  end

  def send_sms_confirmation(phone)
    self.sms_last_request_at = Time.now
    self.sms_confirmation_code = "%06d" % rand(1000000)
    self.save && UserMessager.sms_confirmation(phone, self.sms_confirmation_code).deliver
  end

  def validate_sms_confirmation(code)
    return !self.is_sms_confirmation_code_expired? && code == self.sms_confirmation_code
  end

private
  def assign_defaults
    self.password = self.password_confirmation = "0"*4 unless self.registered?
    self.name = "用户%06d" % rand(100000) if self.name.blank?
  end
end
