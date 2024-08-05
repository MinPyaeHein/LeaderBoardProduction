class Team::CreateService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @teamMemberService = TeamMember::CreateService.new(params)
    @teamEventService = TeamEvent::CreateService.new(params)
  end

  def createTeamWithLeaders
    errors = []
    teams = []
    teamEvents = []
    teamLeaders = []
    unless Event.exists?(@params[:event_id])
      return { errors: ["Event does not exist in the database."], teams: teams, teamEvents: teamEvents, teamLeaders: teamLeaders,}
    end

    @params[:member_ids].each do |member_id|
      resultCheckTeamMember = @teamMemberService.check_team_member(member_id)

      if resultCheckTeamMember[:errors].present?
        errors.concat(resultCheckTeamMember[:errors].flatten)
      else
        team = ::Team.new(
          name: resultCheckTeamMember[:member].name,
          desc: @params[:desc],
          active: true,
          website_link: @params[:website_link],
          organizer_id: @current_user.id,
          total_score: @params[:total_score],
          event_id: @params[:event_id]
        )

        if team.save
          @params[:team_id] = team.id
          resultTeamMember = @teamMemberService.create_one(team.id, member_id, @params[:event_id])
          if resultTeamMember[:teamMember].present?
            resultTeamEvent = @teamEventService.create(@params[:event_id], team.id)
            teamLeaders << resultTeamMember[:teamMember]
            teamEvents << resultTeamEvent[:teamEvent]
            teams << team
          else
            errors.concat(resultTeamMember[:errors].flatten)
          end
        else
          errors.concat(team.errors.full_messages)
        end
      end
    end
    { teams: teams, teamEvents: teamEvents, teamLeaders: teamLeaders, errors: errors }
  end

  def create
    errors = []
    team = nil
    resultTeamEvent = nil
    resultTeamMember = nil
    result = @teamMemberService.check_team_member(@params[:member_id])

    if result[:errors].present?
      errors.concat(result[:errors].flatten)
      { errors: errors }
    else
      ActiveRecord::Base.transaction do
        team = ::Team.new(
          name: @params[:name],
          desc: @params[:desc],
          active: @params[:active],
          website_link: @params[:website_link],
          organizer_id: @current_user.id,
          total_score: @params[:total_score],
          event_id: @params[:event_id],
          pitching_order: @params[:pitching_order]
        )

        if team.save
          @params[:team_id] = team.id
          resultTeamMember = @teamMemberService.create
          resultTeamEvent = @teamEventService.create(@params[:event_id], team.id)

          unless resultTeamMember[:teamMembers].present? && resultTeamEvent[:teamEvent].present?
            errors.concat(team.errors.full_messages) if team.errors.full_messages.present?
            errors.concat(resultTeamMember[:errors].flatten) if resultTeamMember[:errors].present?
            errors.concat(resultTeamEvent[:errors].flatten) if resultTeamEvent[:errors].present?
            raise ActiveRecord::Rollback
          end
        else
          errors.concat(team.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    if errors.empty?
      {
        team: team,
        teamLeader: resultTeamMember[:teamMembers].first,
        teamEvent: resultTeamEvent[:teamEvent],
        tran_investor: resultTeamEvent[:tranInvestor]
      }
    else
      { errors: errors }
    end
  end

  private
end
