# app/serializers/event_serializer.rb
class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :desc, :active,
   :event_type, :updated_at, :created_at, :start_date, :end_date, :start_time,
   :end_time, :all_day, :location, :organizer_id, :score_type_id
  has_one :organizer

end
