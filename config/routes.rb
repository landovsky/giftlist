Rails.application.routes.draw do
  get 'datovestatistiky', to: 'stats#index' 

  # post 'lists/create', to: 'lists#create'
  # get 'lists/index', to: 'lists#index', as: 'lists'
  # get 'lists/show/:id', to: 'lists#show', as: 'list'
  # get 'gifts', to: 'gifts#new'
  # post 'gifts', to: 'gifts#create'
  # get 'gifts/new', to: 'gifts#new'
  
  root 'home#index'
  
  #TODO upravit routy tak, aby nevystavovali to co není nutné
  resources :lists, :gifts
    
  #SESSIONS
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
end
