class TranInvestor< ApplicationRecord
    belongs_to :team_event, :dependent => :destroy
    belongs_to :investor_matrix, :dependent => :destroy
    belongs_to :judge, :dependent => :destroy
end