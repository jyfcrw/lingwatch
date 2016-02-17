class Project < Fume::Settable::Base
  ruby_provider Rails.root.join("spec/settings.rb") if Rails.env.test?
  ruby_provider Rails.root.join("config/settings.rb")
  ruby_provider Rails.root.join("config/settings.local.rb")


  class << self
    attr_accessor :mqtt_client

    def application_name
      Rails.application.class.parent_name.to_s.downcase
    end

    def sms_resend_interval
      self.settings.sms_resend_interval || 60.seconds
    end

    def sms_expired_duration
      self.settings.sms_resend_inteval || 10.minutes
    end

    def method_missing(name, *args, &block)
      self.settings.send(name, *args, &block)
    end
  end
end