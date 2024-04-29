class TeamEvent< ApplicationRecord
  belongs_to :event, :dependent => :destroy
  belongs_to :team, :dependent => :destroy
  has_many :tran_investors
  has_many :tran_scores
  

end
