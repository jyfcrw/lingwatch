set :deploy_to, -> { "/var/www/default/apps/#{fetch(:application)}" }
server 'bstar-dev-facepp', user: 'www-data', roles: %w[web app db], primary: true, sidekiq: true

# bundle_env_variables[:http_proxy] = bundle_env_variables[:https_proxy] = "http://p.wido.me:8123"
