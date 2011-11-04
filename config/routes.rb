ActionController::Routing::Routes.draw do |map|
  map.resources :user_service_roles
  
  map.resources :institional_roles

  map.resources :service_roles

  map.resources :ca_managements

  map.resources :authorizations

  map.resources :section_roles
  map.resources :application
  map.root :controller => "application"
  map.resource "application/logout" => "application#logout"
  map.resource "sessions/act_as" => "sessions#act_as"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

