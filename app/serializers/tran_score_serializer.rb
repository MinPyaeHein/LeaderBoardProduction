class TranScoreSerializer < ActiveModel::Serializer
  attributes :id,:event_id, :judge_id, :team_event_id, :score, :score_matrix_id, :desc, :created_at, :updated_at, :team_name
  has_one :score_matrix
  has_one :team_event
  def team_name
    object.team_event.team.name
  end

end
