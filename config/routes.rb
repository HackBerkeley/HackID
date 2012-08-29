HackidServerRails::Application.routes.draw do
  root :to => "home#index"
  devise_for :user, :controllers => {:registrations => "registrations"}
  resources :users, :only => [:index, :show]
  resources :clients
  get "/hackers" => "home#red_team", :as => "red_team"
  get "/oauth/dialog" => "oauth#dialog"
  post "/oauth/dialog" => "oauth#authorize", :as => :authorize_client
  get "/oauth/access_token" => "oauth#access_token", :as => :access_token
  get "/me" => "users#api"
end
