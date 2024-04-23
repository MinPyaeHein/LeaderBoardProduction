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
        get 'get_teams_by_event_id', on: :collection
      end

    end
  end
  namespace :api do
    namespace :v2 do

      resources :member do
        post 'signUp', on: :collection, to: 'members#create'
        post 'login', on: :collection, to: 'members#login'
        post 'signIn', on: :collection, to: 'members#login'
        patch '',on: :collection, to: 'members#update'
        get ':member_id',on: :collection, to: 'members#get_member_by_id'
      end
        get 'members', to: 'members#index'

      #judge
        post 'transaction',  to: 'tran_investors#create'
        get ':id/transaction', to: 'tran_investors#get_all_tran_investors_by_event'


      #organizer
        post 'event', to: 'events#create'
        post 'scoreMatrix',  to: 'score_matrices#create'
        post 'investMatrix', to: 'investor_matrices#create'
        post 'event/judge',  to: 'judges#create'
        post 'event/teamLeader',  to: 'team_members#create'
        post 'event/team', to: 'teams#create'
        post 'event/teams', to: 'teams#create_team_with_leaders'

      #Add Team member
       post 'team/member', to: 'team_members#create'

      #Event
       get 'events', to: 'events#index'
       get 'event/:id', to: 'events#get_events_by_id'
       put 'event', to: 'events#update'

      #Team
       get 'teams/event/:id', to: 'teams#get_teams_by_event_id'
       get 'team/event/:event_id/judge/:judge_id', to: 'judges#get_judge_by_id'

      #Transcation Log
       get 'transaction/event/:id', to: 'tran_investors#get_all_tran_investors_by_event'
       get 'transaction/event/:event_id/judge/:judge_id', to: 'tran_investors#get_all_tran_investors_by_event_and_judge'

    end
  end
  match "/favicon.ico", to: "application#nothing", via: :all
end
