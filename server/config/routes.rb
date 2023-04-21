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
  resources :users
  post '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'
  get 'all_users', to: 'users#all_users'
  post 'login', to: 'sessions#create'
  get 'login', to: 'sessions#show'
  delete 'logout', to: 'sessions#destroy'
  post 'register', to: 'users#create'
  get 'show', to: 'users#show'



end
