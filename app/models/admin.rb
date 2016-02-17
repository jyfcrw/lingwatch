# == Schema Information
#
# Table name: admins
#
#  id                 :integer          not null, primary key
#  email              :string           default(""), not null
#  crypted_password   :string           default(""), not null
#  login_count        :integer          default(0), not null
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string
#  last_login_ip      :string
#  created_at         :datetime
#  updated_at         :datetime
#  password_salt      :string
#  persistence_token  :string           not null
#  failed_login_count :integer          default(0), not null
#  extra              :text
#

class Admin < ActiveRecord::Base
  acts_as_authentic
  attr_accessor :current_password
  require_accessor :current_password

  validate :validate_current_password, if: :current_password_required?

  def validate_current_password
    errors.add(:current_password) unless valid_password?(self.current_password)
  end

  def require_current_password!
    @current_password_required = true
    @password_changed = true
  end
end
