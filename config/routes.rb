Rails.application.routes.draw do
  root to: proc { [ 200, { "Content-Type" => "application/json" }, [ {
    status: "ok",
    message: "API is running",
    version: "1.0.0"
  }.to_json ] ]}
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
