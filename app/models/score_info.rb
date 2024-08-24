class ScoreInfo< ApplicationRecord
has_many :score_matrix, dependent: :destroy
end
