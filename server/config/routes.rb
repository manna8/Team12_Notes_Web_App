Rails.application.routes.draw do
  resources :notes
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
  resources :users, only: [:create, :show]
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'register', to: 'users#create'

end
