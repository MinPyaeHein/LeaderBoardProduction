class TeamEventSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :event_id, :total_score
  has_many :tran_scores
end
