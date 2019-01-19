Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :admin_events
  resources :events, only: [:index, :show] do
    post :buy, to: 'events#buy', on: :member
  end
  resources :tickets, only: :show

  root 'events#index'
end
