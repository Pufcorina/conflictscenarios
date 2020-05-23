Rails.application.routes.draw do
  devise_for :users, :controllers => { :confirmations => "confirmations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "dashboard#index"
  resources :users do
    delete :destroy
  end


  resource :policies
  get '/security/privacy_policy/', to: 'policies#privacy_policy'
  get '/security/terms_and_conditions/', to: 'policies#terms_and_conditions'
  get '/security/cookies/', to: 'policies#cookie_policy'
  get '/security', to: 'securities#index', :as => :security
  as :user do
    put '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  post '/new_user', to: 'users#create'



end
