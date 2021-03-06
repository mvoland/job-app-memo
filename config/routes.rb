Rails.application.routes.draw do
  get 'job_application_currents/create'
  get 'job_application_archives/update'
  root 'static_pages#home'

  devise_for :users

  resources :users, only: [:show] do
    resources :job_applications do
      resources :job_informations
      resources :job_application_archives
      resources :job_application_currents
    end
  end
end
