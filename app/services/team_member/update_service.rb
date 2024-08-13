class TeamMember::UpdateService
  def initialize(params)
    @params = params
  end

  def update
    @team_member = ::TeamMember.find_by(member_id: @params[:member_id],team_id: @params[:team_id])
    if @team_member.nil?
      return { errors: ["Team member not found in team"] }
    end
    # Retain old values if new ones are null
    @team_member.assign_attributes(
      name: @params[:name] || @team_member.name,
      bio: @params[:bio] || @team_member.bio,
      role: @params[:role] || @team_member.role,
      leader: @params[:leader].nil? ? @team_member.leader : @params[:leader],
      active: @params[:active].nil? ? @team_member.active : @params[:active],
      event_id: @params[:event_id] || @team_member.event_id
    )

    if @team_member.save
      { teamMember: @team_member.reload } # Reload to get the latest data
    else
      { errors: @team_member.errors.full_messages }
    end
  end
end
