class Judge < ApplicationRecord
    belongs_to :Judge, class_name: 'Member'
    belongs_to :event
    
  end