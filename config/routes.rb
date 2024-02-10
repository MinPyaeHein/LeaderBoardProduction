Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
     
      
      resources :event_types, only: [:index, :create]
      resources :score_types, only: [:index, :create]
      resources :teams, only: [:index, :create]
      
      resources :members, only: [:index, :create]
      resources :members do
        post 'login', on: :collection
        get 'logout', on: :collection
      end

      resources :team_members, only: [:index, :create]
      resources :team_members do
        get 'get_team_members_by_team', on: :collection 
      end

      resources :events, only: [:index, :create]
      resources :events do
        get 'get_events_by_id', on: :collection
        
      end
     
      # Add other resourceful routes if needed
    end
  end
end
