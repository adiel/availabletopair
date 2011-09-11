AvailableToPair::Application.routes.draw do
  root :to => "availabilities#index"
  resources :availabilities
  devise_for :users

  resources :users
  resources :tags
  
  match ':id' => "users#index"
  match 'pairs/:id/:action' => "pairs"

end
