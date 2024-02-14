Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      resources :faculties, only: [:index, :create]
      resources :event_types, only: [:index, :create]
      resources :score_types, only: [:index, :create]
      resources :teams, only: [:index, :create]
      resources :judges, only: [:index, :create]
      resources :score_infos, only: [:index, :create]
      resources :score_matrices, only: [:index, :create]
      resources :investor_matrices, only: [:index, :create]
      
      
      resources :members, only: [:index, :create]
      resources :members do
        post 'login', on: :collection
        get 'logout', on: :collection
        get 'events_by_member_id', on: :collection
      end

      resources :team_members, only: [:index, :create]
      resources :team_members do
        get 'get_members_by_team_id', on: :collection 
      end
      resources :judges do
        get 'get_judges_by_event_id', on: :collection 
      end
      resources :editors, only: [:index, :create]
      resources :editors do
        get 'get_editors_by_event_id', on: :collection 
      end

      resources :events, only: [:index, :create]
      resources :events do
        get 'get_events_by_id', on: :collection
        
      end

    end
  end
end
