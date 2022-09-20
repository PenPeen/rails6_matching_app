Rails.application.routes.draw do
  root 'top#index'

  # devise
  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations_override'
    }
  end

  # Profile
  resources :users, only: [:index, :show]

  # reaction'
  resources :reactions, only: [:create]

end
