if %w[ development test ].include?(Rails.env)
  Sidekiq.logger = Rails.logger
end

redis = { :namespace => 'sidekiq:lingwatch' }

Sidekiq.configure_server do |config|
  config.redis = redis
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
