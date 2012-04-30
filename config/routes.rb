ActionController::Routing::Routes.draw do |map|
  map.resources :service_roles
  
  map.resources :institional_roles

  map.resources :service_roles

  map.resources :ca_managements

  map.resources :authorizations, :only => [:index, :update]
  map.resources :preparealimits
  map.resources :section_roles
  map.resources :application
  map.root      :controller => "static", :action => "index"
 # map.resource "application/logout" => "application#logout"
  map.resource "sessions/act_as" => "sessions#act_as"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

