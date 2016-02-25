source "https://ruby.taobao.org"

gem 'bundler', '>= 1.8.4'

gem 'rails', '4.2.2'
gem "rails-i18n", "4.0.8"
gem "pg", "0.18.4"
gem "fume", "0.10.0"
gem "fume-settable", "0.0.3"

# model
gem "symbolize", "4.5.0"
gem "ransack", "1.7.0"
gem "authlogic", "3.4.6"
gem "cancancan", "1.13.1"
gem "fume-cancan", "0.0.4"
gem "activerecord-typedstore", "0.6.1"
gem "carrierwave", "0.10.0"
gem "mini_magick", "4.0.1", require: false

# backgound
gem "sinatra", ">= 1.4.5", require: false
gem "sidekiq", "3.4.2"
gem "cocaine", "0.5.8"
gem "whenever", "0.9.4", require: false

# views
gem "kaminari", "0.16.1"
gem "kaminari-bootstrap", "3.0.1"
gem "fume-nav", "0.0.3"
gem "jbuilder", "2.2.4"
gem "simple_form", "3.0.2"
gem "simple_captcha2", "0.3.4"
gem "faraday", "0.9.0"
gem "faraday_middleware", "0.9.1"
gem "hashie", "3.3.1"
gem "user_agent_parser", "~> 2.2.0"


# assets
gem "bootstrap-sass", "3.3.6"
gem "compass-rails", "2.0.5"
gem "sass-rails", "5.0.4"
gem "coffee-rails", "4.1.0"
gem "uglifier", ">= 2.7.2"
# gem "therubyracer", platforms: :ruby
# gem "js-routes", "0.9.9"

# rails-assets
source 'https://rails-assets.org' do
  gem "rails-assets-jquery", "1.11.1" # support for ie8
  gem "rails-assets-jquery-ujs", "1.0.1"
  gem "rails-assets-bootstrap-sass-official", "3.3.1"
  gem "rails-assets-bootstrap-filestyle", "1.1.2"
  gem "rails-assets-font-awesome", "4.2.0"
  gem "rails-assets-bootstrap-select", "1.6.3"
  gem "rails-assets-clockpicker", "0.0.7"
  gem "rails-assets-bootstrap-switch", "3.2.2"
  gem "rails-assets-moment", "2.8.3"
  gem "rails-assets-eonasdan-bootstrap-datetimepicker", "3.1.3"
  gem "rails-assets-lodash", "2.4.1"
  gem 'rails-assets-select2', "4.0.1"
end

group :development, :test do
  gem "pry-rails"
  gem "pry-byebug"
end

group :development do
  # gem "binding_of_caller"
  gem "quiet_assets"
  gem "puma"

  # gem "traceroute"
  gem "bullet"
  # gem "brakeman", require: false
  # gem "rails_best_practices"

  # gem "parallel_tests"
  gem "annotate", require: false
  gem "capsum", ">= 1.0.2", require: false
  gem 'capistrano-sidekiq', "0.5.4"
end

