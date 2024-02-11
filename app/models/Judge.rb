class Judge < ApplicationRecord
    belongs_to :member
    belongs_to :judgeEvent,class_name: 'Event', foreign_key: 'event_id'
    
  end