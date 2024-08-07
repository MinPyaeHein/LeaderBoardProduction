class TranInvestorSerializer < ActiveModel::Serializer
    attributes :id, :amount, :judge_id, :team_event_id, :event_id, :created_at, :updated_at
    attribute :judge_member_name, if: -> { object.judge.present? } do
        object.judge.member.name
    end
    attribute :team_name, if: -> { object.team_event.present? } do
        object.team_event.team.name
    end
end
