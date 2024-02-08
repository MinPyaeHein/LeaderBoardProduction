class Event < ApplicationRecord
    belongs_to :event_type
    belongs_to :score_type
    belongs_to :organizer, class_name: 'Member'
    validates :organizer_id, presence: true
  end