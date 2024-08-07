class MemberVote::CreateService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def create
    member_vote = find_or_initialize_member_vote

    if member_vote.persisted?
      member_vote.status = !member_vote.status
    else
      member_vote.status = true

    end

    if member_vote.save
      { member_vote: member_vote }
    else
      { errors: member_vote.errors.full_messages }
    end
  end

  private
  def find_or_initialize_member_vote
    MemberVote.find_or_initialize_by(member_id: @current_user.member_id, team_id: @params[:team_id])
  end
end
