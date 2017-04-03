Rails.application.routes.draw do
  root 'home#index'

  post 'urls' => 'urls#create', as: 'urls'
  get 'urls/destroy/:id' => 'urls#destroy', as: 'url_destroy'

  get 'datovestatistiky' => 'stats#index'

  if Rails.env.development?
  resources :users
  end

  #TODO upravit routy tak, aby nevystavovaly to co není nutné
  resources :lists, :gifts

  #SESSIONS
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/auth' => 'sessions#token_auth', as: 'auth'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  post '/invite' => 'users#invite'

end
