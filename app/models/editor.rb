class Editor < ApplicationRecord
    belongs_to :member, dependent: :destroy
    belongs_to :event, dependent: :destroy
   
    
  end