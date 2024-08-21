class TeamWithVoteCountSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :event_id, :organizer_id, :vote_count
  has_many :members

  def vote_count
    object.member_votes.where(status: true).count
  end
end
