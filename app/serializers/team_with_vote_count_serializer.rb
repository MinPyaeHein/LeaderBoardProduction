# app/serializers/team_with_vote_count_serializer.rb
class TeamWithVoteCountSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :event_id, :organizer_id, :vote_count
  has_many :members

  def vote_count
    object.member_votes.count
  end
end
