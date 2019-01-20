# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :admin_events
  resources :events, only: %i[index show] do
    post :buy, to: 'events#buy', on: :member
  end
  resources :tickets, only: :show

  get 'tickets_scanner', to: 'tickets_scanner#show', as: :tickets_scanner
  post 'tickets_scanner', to: 'tickets_scanner#scan', as: :scan_ticket

  root 'events#index'
end
