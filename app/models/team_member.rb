class TeamMember< ApplicationRecord
  belongs_to :member, :dependent => :destroy
  belongs_to :team, :dependent => :destroy
  

  
end