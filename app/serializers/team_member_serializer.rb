class TeamMemberSerializer < ActiveModel::Serializer
    attributes :id, :member_id, :team_id, :leader, :active, :created_at,:updated_at,:event_id
    has_one :team
    has_one :member
  end
