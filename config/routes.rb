Rails.application.routes.draw do

  post 'urls' => 'urls#create', as: 'urls'
  get 'urls/destroy/:id' => 'urls#destroy', as: 'url_destroy'
  get 'urls/open/:digest' => 'urls#open', as: 'url_open'

  get 'datovestatistiky' => 'stats#index'

  get 'gift/:id/take' => 'gifts#take', as: 'take_gift'

  case Rails.env
  when "development"
    get 'glyphs' => 'home#glyphs'
  end

  #home
  get '/thank_you' => 'home#thank_you'

  #ROOT
  get '/' => 'lists#index', constraints: LoggedInConstraint.new
  root 'home#index'

  #GIFTS
  get 'gifts' => 'lists#index'

  #TODO upravit routy tak, aby nevystavovaly to co není nutné
  resources :lists, :gifts

  #SESSIONS
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/auth' => 'sessions#token_auth', as: 'auth'

  #USERS
  get '/user/:id' => 'users#profile', as: 'user'     #kvůli bootstrap_form v profile.html.erb
  patch '/user/:id' => 'users#update'
  get '/signup' => 'users#new'
  get '/users' => 'users#profile'                    # registrace > post s chybou > refresh > signup
  post '/users' => 'users#create'
  post '/invite' => 'users#invite'
  get '/registration' => 'users#guest_registration'
  get '/profile' => 'users#profile'
  #TODO zvážit jestli by invite a uninvite nemělo sedět spíš v list controlleru
  get '/lists/:list_id/uninvite/:user_id' => 'users#uninvite', as: 'uninvite'
  get '/password_recovery' => 'users#password_recovery'   # žádost o obnovu přístupu (form)
  get '/recover_password'  => 'users#password_recovery'   # pro obnovení okna po zaslání požadavku na obnovu hesla
  post '/recover_password' => 'users#recover_password'    # žádost o obnovu přístupu (controller)
  get '/reset_password'    => 'users#reset_password'      # form na nové heslo

end
