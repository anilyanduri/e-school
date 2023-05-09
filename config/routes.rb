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
    resources :batches do
      member do
        put 'endorse/:status', action: :endorse, constraints: { status: ['approve', 'reject'] }, as: :endrose
      end
    end
  end
  resources :courses, only: [:index, :show] do
    member do
      get 'study'
    end
  end
  resources :batches, only: [:index, :show] do
    member do
      put 'enroll'
    end
  end
  resources :enrollments, only: [] do
    member do
      put 'progress/:batch_id', action: :progress, as: :progress
      put 'complete/:batch_id', action: :complete, as: :complete
    end
  end

end
