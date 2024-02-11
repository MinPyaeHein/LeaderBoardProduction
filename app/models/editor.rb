class Editor < ApplicationRecord
    belongs_to :member
    belongs_to :editorEvent,class_name: 'Event', foreign_key: 'event_id'
   
    
  end