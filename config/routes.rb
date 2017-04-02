Rails.application.routes.draw do
  post 'urls', to: 'urls#create', as: 'urls'
  get 'urls/destroy/:id', to: 'urls#destroy', as: 'url_destroy'  
  
  #TODO disable this route
  get 'link/new', to: 'link#new'
  get 'datovestatistiky', to: 'stats#index' 

  

  # post 'lists/create', to: 'lists#create'
  # get 'lists/index', to: 'lists#index', as: 'lists'
  # get 'lists/show/:id', to: 'lists#show', as: 'list'
  # get 'gifts', to: 'gifts#new'
  # post 'gifts', to: 'gifts#create'
  # get 'gifts/new', to: 'gifts#new'
  
  root 'home#index'
  
  #TODO upravit routy tak, aby nevystavovaly to co není nutné
  resources :lists, :gifts
    
  #SESSIONS
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/auth', to: 'sessions#token_auth'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
  
end
