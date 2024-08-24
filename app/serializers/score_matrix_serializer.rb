class ScoreMatrixSerializer < ActiveModel::Serializer
    attributes :id, :weight, :max, :min, :event_id, :score_info_id, :name, :weight
    belongs_to :score_info
end
