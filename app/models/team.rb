class Team < ApplicationRecord
    enum status: { pending: 1, approved: 2}
    has_many :team_members
    has_many :team_events
    has_many :tran_scores
    has_many :members, through: :team_members
    belongs_to :event
    belongs_to :organizer, class_name: 'Member'
    has_many :member_votes
  end
