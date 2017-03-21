Rails.application.routes.draw do
  get 'lists/new'

  get 'lists/create'

  get 'lists/index'

  get 'lists/show'

  get 'gifts/index'

  get 'gifts/new'

  get 'gifts/create'

  get 'gifts/show'

  get 'gifts/grab'

  get 'gifts/release'

  get 'gifts/destroy'

  get 'gifts/edit'

  get 'gifts/update'

  root 'home#index'
  
  #TODO upravit routy tak, aby nevystavovali to co není nutné
  resources :users, :lists, :gifts
    
  #SESSIONS
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
end
