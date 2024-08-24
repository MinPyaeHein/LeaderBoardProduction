class ScoreMatrix< ApplicationRecord
    belongs_to :event, dependent: :destroy
    belongs_to :score_info, dependent: :destroy
end
