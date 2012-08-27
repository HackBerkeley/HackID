HackidServerRails::Application.routes.draw do
  root :to => "home#index"
  devise_for :user
  resources :users, :only => [:index, :show]
end
