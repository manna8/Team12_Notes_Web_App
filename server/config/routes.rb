Rails.application.routes.draw do
  resources :friendships
  resources :notes_collections

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # post "/login" => "sessions#create"
  #
  # post '/users' => 'users#create'
  #
  # get 'users/get' => 'users#get'
  resources :notes
  post 'create_note', to: 'notes#create'
  get  'notes_sharing', to: 'notes#my_shared_notes'
  get 'notes_shared_with_me', to: 'notes#shared_with_me_notes'
  post '/notes/:id', to: 'notes#update'
  post '/notes/:id/sharing_update', to: 'notes#sharing_update'
  get '/notes/:id/shared_with' , to: 'notes#shared_users'


  resources :notes_collections
  post '/notes_collection/:id/sharing_update', to: 'notes_collections#sharing_update'
  get  'notes_collections_sharing', to: 'notes_collections#my_shared_collections'
  get 'notes_collections_shared_with_me', to: 'notes_collections#shared_with_me_collections'
  get '/notes_collection/:id/shared_with' , to: 'notes_collections#shared_users'

  resources :users
  get '/users/:id', to: 'users#show_user_with_id'
  post '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'
  get 'all_users', to: 'users#all_users'
  get 'show', to: 'users#show'
  post 'register', to: 'users#create'
  get "friends_with_id", to: "users#friends"

  post 'login', to: 'sessions#create'
  get 'login', to: 'sessions#show'
  delete 'logout', to: 'sessions#destroy'


  get 'friends/sent', to: "friendships#sent_friend_requests"
  get 'friends/received', to: "friendships#received_friend_requests"
  get "friends", to: "friendships#friends"


end
