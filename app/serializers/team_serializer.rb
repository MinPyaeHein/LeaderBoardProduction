class TeamSerializer < ActiveModel::Serializer
    attributes :id, :event_id, :active, :desc, :name, :pitching_order, :website_link
    has_many :team_events, key: :teamEvents
  end
