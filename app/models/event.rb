class Event < ApplicationRecord
    enum status: { ongoing: 1, past: 2, future: 3 }
    belongs_to :event_type, dependent: :destroy
    belongs_to :score_type, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :judges, dependent: :destroy
    belongs_to :organizer, dependent: :destroy, class_name: 'Member'
    validates :organizer_id, presence: true
  end