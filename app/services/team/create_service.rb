class Team::CreateService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @teamMemberService = TeamMember::CreateService.new(params)
    @teamEventService = TeamEvent::CreateService.new(params,current_user)
  end

  def createTeamWithLeaders
    errors = []
    teams = []
    teamEvents = []
    teamLeaders = []

    unless Event.exists?(@params[:event_id])
      return { success: false ,message: {errors: "Event does not exist in the database."}}
    end

    ActiveRecord::Base.transaction do
      @params[:member_ids].each do |member_id|
        result_check_team_member = @teamMemberService.check_team_member(member_id, @params[:event_id])
        if result_check_team_member[:errors].present?
          errors.concat(result_check_team_member[:errors].flatten)
        else
          puts("@params[:status]==",@params[:status])
          team = ::Team.new(
            name: result_check_team_member[:member].name,
            desc: @params[:desc],
            active: true,
            website_link: @params[:website_link],
            organizer_id: @current_user.member_id,
            total_score: @params[:total_score],
            event_id: @params[:event_id],
            status: "pending"
          )

          if team.save
            @params[:team_id] = team.id
            result_team_member = @teamMemberService.create_one(team.id, member_id, @params[:event_id])

            if result_team_member[:teamMember].present?
              result_team_event = @teamEventService.create(@params[:event_id], team.id)
              teamLeaders << result_team_member[:teamMember]
              teamEvents << result_team_event[:teamEvent]
              teams << team
            else
              errors.concat(result_team_member[:errors].flatten)
              raise ActiveRecord::Rollback
            end
          else
            errors.concat(team.errors.full_messages)
            raise ActiveRecord::Rollback
          end
        end
      end
    end
    {success: true,message: { teams: teams, teamEvents: teamEvents, teamLeaders: teamLeaders, errors: errors }}
  end

  def create
    errors = []
    team = nil
    result_team_event = nil
    result_team_member = nil
    result = @teamMemberService.check_team_member(@params[:member_id], @params[:event_id])

    if result[:errors].present?
      errors.concat(result[:errors].flatten)
      return { success: false, message: { errors: errors } }
    else
      ActiveRecord::Base.transaction do
        team = ::Team.new(
          name: @params[:name],
          desc: @params[:desc],
          active: @params[:active],
          website_link: @params[:website_link],
          organizer_id: @current_user.member.id,
          total_score: @params[:total_score],
          event_id: @params[:event_id],
          pitching_order: @params[:pitching_order],
          status: "pending"
        )

        if team.save
          @params[:team_id] = team.id
          result_team_member = @teamMemberService.create_one(@params[:team_id], @params[:member_id], @params[:event_id])
          result_team_event = @teamEventService.create(@params[:event_id], team.id)

          unless result_team_member[:teamMember].present? && result_team_event[:teamEvent].present?
            errors.concat(result_team_member[:errors].flatten) if result_team_member[:errors].present?
            errors.concat(result_team_event[:errors].flatten) if result_team_event[:errors].present?
            raise ActiveRecord::Rollback
          end
        else
          errors.concat(team.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    if errors.empty?
      {success: true ,
        message:{
        team: team,
        teamLeader: result_team_member[:teamMember],
        teamEvent: result_team_event[:teamEvent]
      }}
    else
      { errors: errors }
    end

  end
end
