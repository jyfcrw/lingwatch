class UserMessager
  def self.sms_confirmation(phone, code)
    SmsDeliverProxy.new(phone, code)
  end

  class SmsDeliverProxy < Struct.new(:phone, :code)
    def deliver
      SmsDeliverWorker.perform_async(phone, code)
    end
  end
end