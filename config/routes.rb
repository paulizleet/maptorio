Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   
  get "modsuites/:id/graph" => 'modsuites#graph'
  resources :modsuites
  root "modsuites#index"
end
