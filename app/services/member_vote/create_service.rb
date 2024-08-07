class MemberVote::CreateService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def create
    member_vote = find_or_initialize_member_vote

    if member_vote.persisted?
      member_vote.status = !member_vote.status
      message = 'Member Vote status updated successfully'
    else
      member_vote.status = true
      message = 'Member Vote created successfully'
    end

    if member_vote.save
      { message: message }
    else
      { errors: member_vote.errors.full_messages }
    end
  end

  private
  def find_or_initialize_member_vote
    MemberVote.find_or_initialize_by(member_id: @current_user.member_id, team_id: @params[:team_id])
  end
end
