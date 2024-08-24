# app/serializers/event_serializer.rb
class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :desc, :active,
   :event_type, :updated_at, :created_at, :start_date, :end_date, :start_time,
   :end_time, :all_day, :location, :organizer_id, :score_type_id
   belongs_to :organizer
   has_many :judges
   has_many :teams
   has_many :editors
   has_one :event_type
   has_one :score_type
   has_many :investor_matrices
   has_many :score_matrices, serializer: ScoreMatrixSerializer
end
