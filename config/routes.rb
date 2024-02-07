Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      resources :members, only: [:index, :create]
      resources :event_types, only: [:index, :create]
      resources :events, only: [:index, :create]
      resources :score_types, only: [:index, :create]
      resources :members do
        post 'login', on: :collection
        delete 'logout', on: :collection
      end
     
      # Add other resourceful routes if needed
    end
  end
end
