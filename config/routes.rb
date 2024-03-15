Rails.application.routes.draw do
  root 'score_boards#home'
  resources :score_boards do
    get 'score_boards', to: 'score_boards#home'
  end
  namespace :api do
    namespace :v1 do
      resources :faculties, only: [:index, :create]
      resources :event_types, only: [:index, :create]
      resources :score_types, only: [:index, :create]
      resources :judges, only: [:index, :create]
      resources :score_infos, only: [:index, :create]
      resources :score_matrices, only: [:index, :create]
      resources :investor_matrices, only: [:index, :create] 
      resources :team_events, only: [:index]
      resources :tran_investors, only: [:index, :create]
      resources :tran_investors do
        post 'invest_amounts_by_team', on: :collection
        post 'get_all_tran_investors_by_event', on: :collection
        
      end

      resources :members, only: [:index, :create, :update]
      resources :members do
        get 'score_boards', on: :collection
        post 'login', on: :collection
        get 'logout', on: :collection
        delete 'reset_all', on: :collection
        get 'events_by_member_id', on: :collection
        post 'get_member_by_id', on: :collection
      end

      resources :team_members, only: [:index, :create]
      resources :team_members do
        get 'get_members_by_team_id', on: :collection 
      end
      resources :judges do
        get 'get_judges_by_event_id', on: :collection 
        post 'get_judge_by_id', on: :collection
      end
      resources :editors, only: [:index, :create]
      resources :editors do
        get 'get_editors_by_event_id', on: :collection 
      end
      resources :events, only: [:index, :create]
      resources :events do
        post 'get_events_by_id', on: :collection
        post 'get_events_by_judge_id', on: :collection
      end

      resources :teams, only: [:index, :create]
      resources :teams do
        post 'create_team_with_leaders', on: :collection
      end

    end
  end
  match "/favicon.ico", to: "application#nothing", via: :all
end
