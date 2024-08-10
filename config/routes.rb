require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'
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
        post 'gestSignIn', on: :collection, to: 'members#gest_login'
        post 'signIn', on: :collection, to: 'members#login'
        patch '',on: :collection, to: 'members#update'
        get ':member_id',on: :collection, to: 'members#get_member_by_id'
        post 'vote/team', on: :collection, to: 'member_votes#create'
      end
      get 'members', to: 'members#index'

      #judge
        post 'transaction',  to: 'tran_investors#create'
        get ':id/transaction', to: 'tran_investors#get_all_tran_investors_by_event'
        post 'score',  to: 'tran_scores#create'
        get 'judges/event/:event_id', to: 'judges#get_judges_by_event_id'
        get 'events/judge/:judge_id', to: 'events#get_events_by_judge_id'
        get 'score/team/categories', to: 'tran_score#score_team_by_all_categories'

      #organizer
        post 'event', to: 'events#create'
        post 'event/scoreMatrix',  to: 'score_matrices#create'
        post 'event/investMatrix', to: 'investor_matrices#create'
        post 'event/judges',  to: 'judges#create'
        post 'event/editors',  to: 'editors#create'
        post 'event/teamLeader',  to: 'team_members#create'
        post 'event/team', to: 'teams#create'
        post 'event/teams', to: 'teams#create_team_with_leaders'
        get 'event/scoreTypes', to: 'score_types#index'
        post 'event/scoreMatrix', to: 'score_matrices#create'
        put 'event/:event_id/scoreType/:score_type_id', to: "events#update_event_score_type"
        put 'event/team/status', to: "teams#update_status"
        put 'event/status', to: "events#update_status"


      #Team Leader
       post 'team/members', to: 'team_members#create'
       patch 'team', to: 'teams#update'
       delete 'team/:team_id/member/:member_id', to: 'team_members#remove_team_member'

      #Event
       get 'events', to: 'events#index'
       get 'event/:id', to: 'events#get_events_by_id'
       put 'event', to: 'events#update'
       get 'scoreCategory/event/:event_id', to: 'score_matrices#get_score_matrix_by_event_id'
       get 'events/member/:member_id', to: 'events#get_event_by_member_id'

      #Team
       get 'teams/event/:event_id/totalAmount', to: 'teams#get_teams_by_event_id'
       get 'team/event/:event_id/judge/:judge_id', to: 'judges#get_judge_by_id'
       get 'teams/event/:event_id/totalScore', to: 'tran_scores#get_teams_total_score'
       get 'teams/event/:event_id/categoriesScore', to: 'tran_scores#get_teams_score_by_category'
       get 'scoreCategory/event/:event_id', to: 'score_matrices#get_score_matrix_by_event_id'
       get 'teams/event/:event_id/categoriesScore/judge/:member_id', to: 'tran_scores#get_all_team_score_categories_by_judge'
       get '/team/:team_id/event/:event_id/categoriesScore/judge', to: 'tran_scores#get_one_team_score_category_by_individual_judge'
       get 'team/:team_id/event/:event_id/categoriesScores/judges', to: "tran_scores#get_one_team_score_categories_by_all_judges"
       get '/teams/event/:event_id/categoriesScore/judge', to: 'tran_scores#get_all_teams_score_category_by_individual_judges'
       get 'teams/:member_id', to: 'teams#get_teams_by_member_id'
       get 'team/:team_id', to: 'teams#get_teams_by_id'
       put 'team', to: 'teams#update'


      #Transcation Log
       get 'transaction/event/:id', to: 'tran_investors#get_all_tran_investors_by_event'
       get 'transaction/event/:event_id/judge/:judge_id', to: 'tran_investors#get_all_tran_investors_by_event_and_judge'
       get 'transactionScore/event/:event_id', to: 'tran_scores#get_all_tran_score_by_all_judges'


    end
  end
  match "/favicon.ico", to: "application#nothing", via: :all

end
