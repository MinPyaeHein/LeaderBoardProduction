class Team < ApplicationRecord
    has_many :team_members
    has_many :team_events
    has_many :tran_scores
    has_many :members, through: :team_members
    belongs_to :event
    belongs_to :organizer, class_name: 'Member'
  end
