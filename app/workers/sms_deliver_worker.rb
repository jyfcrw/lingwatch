class SmsDeliverWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sms
  sidekiq_options retry: 1
  sidekiq_retry_in { |count| 5 + 10 * count } # 3, 8, 13

  def perform(phone, code)
    conn = Faraday.new do |conn|
      conn.request  :json
      conn.response :raise_error
      conn.response :json
      conn.adapter  Faraday.default_adapter
    end

    response = conn.post do |req|
      req.url Project.leancloud_send_sms_url
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-AVOSCloud-Application-Id'] = Project.leancloud_appid
      req.headers['X-AVOSCloud-Application-Key'] = Project.leancloud_appkey
      req.body = { mobilePhoneNumber: phone, template: "general", xcode: code.to_s }.to_json
    end

    if response.body['code'].present?
      raise "Leancloud SMS sent failed, Code: #{response.body['code']}, Error: #{response.body['error']}"
    end
  end
end