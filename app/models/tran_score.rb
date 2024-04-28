class TranScore< ApplicationRecord
    belongs_to :team_event
    belongs_to :judge
    belongs_to :event
    belongs_to :score_matrix
end
