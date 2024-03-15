class TranInvestorSerializer < ActiveModel::Serializer
    attributes :id, :amount, :investor_matrix_id, :judge_id, :team_event_id, :event_id
    has_one :judge
end