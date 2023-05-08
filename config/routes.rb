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

  namespace :admin do
    resources :schools do
      member do
        put 'toogle_status'
        put 'toogle_school_admin'
      end
    end
  end

  scope :admin, as: :admin do
    resources :courses
    resources :batches
  end
  resources :courses, only: [:index, :show]
  resources :batches, only: [:index, :show]

end
