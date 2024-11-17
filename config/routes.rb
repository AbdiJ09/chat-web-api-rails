Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    resources :chatrooms, only: [ :index,  :create, :show ] do
      member do
        post "join"
        get "join-status", to: "chatrooms#join_status"
        delete "leave", to: "chatrooms#leave_chatroom"
      end
      resources :messages, only: [ :create, :index ]
    end
    resources :users, only: [ :create ]
  end
end
