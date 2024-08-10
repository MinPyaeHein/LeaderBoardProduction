# app/serializers/event_serializer.rb
class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :organizer_name

  def organizer_name
    object.organizer.name
  end
end
