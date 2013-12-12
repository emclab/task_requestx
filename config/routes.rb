TaskRequestx::Engine.routes.draw do
  resources :requests

  root :to => 'requests#index'
end
