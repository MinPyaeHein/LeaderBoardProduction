class Event < ApplicationRecord
    enum status: { ongoing: 1, past: 2, future: 3 }
    belongs_to :event_type
    belongs_to :score_type
    has_many :teams
    has_many :judges
    has_many :editors
    belongs_to :organizer, class_name: 'Member', foreign_key: 'organizer_id'
    validates :organizer_id, presence: true
  end
