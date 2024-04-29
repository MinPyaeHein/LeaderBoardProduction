class TranScoreSerializer < ActiveModel::Serializer
  attributes :id,:event_id, :judge_id, :team_id, :score, :score_matrix_id, :desc

end


