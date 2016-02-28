Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile << Proc.new { |path|  path =~ /\.(eot|svg|ttf|woff)\z/ }
Rails.application.config.assets.precompile += %w( backend.* ie8.* mobile.* )
