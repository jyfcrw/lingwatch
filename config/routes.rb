require 'sidekiq/web'

Rails.application.routes.draw do

  scope module: "backend", path: "backend" do
    get    "sign_in"  => "sessions#new", as: "new_admin_session"
    post   "sign_in"  => "sessions#create", as: "admin_session"
    delete "sign_out" => "sessions#destroy", as: "destroy_admin_session"
  end

  namespace :backend do
    mount Sidekiq::Web => '/sidekiq'

    root to: "main#root"
    resources :admins
    resource  :profiles
    resources :users do
      resources :user_agents
      resources :watches
    end

    resources :devices
    resources :watches do
      resource :binding, controller: "watch_binding"
      resource :dialogue, controller: "watch_dialogue"
    end
  end

  namespace :mq, defaults: { format: "json" } do
    root to: "main#root"

    post "auth/authenticate"      => "auth#authenticate"
    post "auth/publish"           => "auth#pulbish"
    post "auth/subscribe"         => "auth#subscribe"

    post "device/state"           => "device#state"
    post "device/data"            => "device#update"

    # post "message"                => "message#create"
  end

  namespace :api, path: nil, constraints: { subdomain: 'api' }, defaults: { format: "json" } do
    namespace :v1 do
      root to: "main#root"
      post "sign_in"           => "main#sign_in"
      post "sign_up"           => "main#sign_up"
      post "password_recovery" => "main#password_recovery"

      get  "profile"           => "user#profile"
      post "change_profile"    => "user#change_profile"
      post "change_password"   => "user#change_password"
      post "sign_out"          => "user#sign_out"

      namespace :w do
        root to: "main#root"
        post "auth"          => "main#auth"
        post "bind"          => "main#bind"
        post "unbind"        => "device#unbind"

        resource "dialogue" do
          post "join", "exit"
        end
      end
    end
  end

end
