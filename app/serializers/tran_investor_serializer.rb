class TranInvestorSerializer < ActiveModel::Serializer
    attributes :id, :amount, :investor_matrix_id, :judge_id, :team_event_id, :event_id
    has_one :judge
    attribute :judge_member_name, if: -> { object.judge.present? } do
        object.judge.member.name
    end
end