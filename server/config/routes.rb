Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/login" => "login#login"

  post '/users' => 'users#create'

  get 'users/get' => 'users#get'

end
