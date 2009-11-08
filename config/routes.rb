ActionController::Routing::Routes.draw do |map|
  map.root :controller => "availabilities"
  map.resources :availabilities
  map.resources :user_sessions
  map.resources :users
  map.resources :tags
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.connect ':id.:format', :controller => :users, :action => :index
  map.connect 'pairs/:id/:action', :controller => :pairs, :conditions => { :method => :post }

end
