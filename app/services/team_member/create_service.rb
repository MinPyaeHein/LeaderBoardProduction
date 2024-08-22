class TeamMember::CreateService
  def initialize(params)
    @params = params
  end

  def create
    team_members = []
    errors = []

    @params[:member_ids].each do |member_id|
      result = check_team_member(member_id, @params[:event_id])

      if result[:errors].present?
        errors << result[:errors]
      else
        team_member = ::TeamMember.new(
          team_id: @params[:team_id],
          member_id: member_id,
          event_id: @params[:event_id],
          active: @params[:active],
          leader: @params[:leader]
        )

        if team_member.save
          team_members << team_member
        else
          errors << team_member.errors.full_messages
        end
      end
    end

    { teamMembers: team_members, errors: errors }
  end

  def create_one(team_id, member_id, event_id)
    result = check_team_member(member_id, event_id)

    return { errors: result[:errors] } if result[:errors].present?

    team_member = ::TeamMember.new(
      team_id: team_id,
      member_id: member_id,
      event_id: event_id,
      active: true,
      leader: true
    )

    if team_member.save
      { teamMember: team_member }
    else
      { errors: team_member.errors.full_messages }
    end
  end

  def check_team_member(member_id, event_id)
    member = ::Member.find_by(id: member_id, active: true)
    return { errors: ["Member does not exist in the database."] } if member.nil?

    member_in_another_team = ::TeamMember.find_by(member_id: member_id, event_id: event_id, active: true)
    return { errors: ["This member #{member.users.first.email} is already part of another team."] } if member_in_another_team.present?

    existing_team_member = ::TeamMember.find_by(team_id: @params[:team_id], member_id: member_id, active: true)
    return { errors: ["This member #{member.users.first.email} is already part of the team."] } if existing_team_member.present?

    judge=::Judge.find_by(event_id: event_id, member_id: member_id)
    return { errors: ["A judge cannot become Team Member",member.name] } if judge.present?

    { member: member }
  end
end
