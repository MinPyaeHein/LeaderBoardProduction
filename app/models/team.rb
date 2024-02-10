class Team < ApplicationRecord
    belongs_to :event
    belongs_to :organizer, class_name: 'Member'
    validates :organizer_id, presence: true
  end