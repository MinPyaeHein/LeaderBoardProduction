class JudgeSerializer < ActiveModel::Serializer
    attributes :id, :member_id, :current_amount, :judge_type, :event_id
    has_one :member
    has_many :tran_scores
end
