class ScoreMatrixSerializer < ActiveModel::Serializer
    attributes :id, :weight, :max, :min, :event_id, :score_info_id, :name
    has_one :score_info
end
