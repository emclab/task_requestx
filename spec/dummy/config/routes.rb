Rails.application.routes.draw do

  get "user_menus/index"

  mount TaskRequestx::Engine => "/task_requestx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount FixedTaskProjectx::Engine => '/projectx'
  mount TemplateTaskx::Engine => '/taskx'
  mount Kustomerx::Engine => '/kustomerx'
  mount TaskTemplatex::Engine => '/templatex'
  mount SimpleTypex::Engine => '/typex'
  mount Searchx::Engine => '/searchx'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
