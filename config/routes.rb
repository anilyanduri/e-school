Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#home"

  get   'login',  controller: :login, action: :new
  post  'login',  controller: :login, action: :login
  get   'logout', controller: :login, action: :logout
  post  'logout', controller: :login, action: :logout

  get   'register', controller: :registration, action: :new
  post  'register', controller: :registration, action: :create
end