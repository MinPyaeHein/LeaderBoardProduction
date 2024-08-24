class ScoreMatrixSerializer < ActiveModel::Serializer
    attributes :id, :weight, :max, :min, :event_id, :score_info_id, :name, :weight, :short_term
    def short_term
      object.score_info&.short_term
    end

end
