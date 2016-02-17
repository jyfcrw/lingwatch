set :application, 'lingwatch'
set :repo_url, '.git'
set :default_env, { path: "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }

fetch(:linked_files).concat %w{
  config/database.yml
  config/settings.local.rb
  config/secrets.yml
}

fetch(:linked_dirs).concat %w{
  public/uploads
}

