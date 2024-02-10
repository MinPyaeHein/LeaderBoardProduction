class Event < ApplicationRecord
    enum status: { ongoing: 1, past: 2, fature: 3 }
    belongs_to :event_type
    belongs_to :score_type
    has_many :teams
    has_many :judges, class_name: 'Member'
    belongs_to :organizer, class_name: 'Member'
    validates :organizer_id, presence: true
  end