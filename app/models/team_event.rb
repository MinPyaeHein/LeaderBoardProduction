class TeamEvent< ApplicationRecord
  belongs_to :event, :dependent => :destroy
  belongs_to :team, :dependent => :destroy
  
end