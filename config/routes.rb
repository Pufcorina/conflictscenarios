Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", confirmations: 'users/confirmations' }
  resources :users do
    member do
      get :confirm_email
    end
  end
end
