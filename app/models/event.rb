class Event < ApplicationRecord
    belongs_to :event_type
    belongs_to :score_type
    has_many :teams
    has_many :judges, class_name: 'Judge'
    belongs_to :organizer, class_name: 'Member'
    validates :organizer_id, presence: true
  end