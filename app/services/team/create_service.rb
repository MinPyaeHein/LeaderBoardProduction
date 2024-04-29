# app/services/member_service.rb
    class Team::CreateService
      def initialize(params,current_user)
        @params = params
        @current_user = current_user
        @teamMemberService = TeamMember::CreateService.new(params)
        @teamEventService = TeamEvent::CreateService.new(params)
      end

      def createTeamWithLeaders
        errors=[]
        teams=[]
        teamEvents=[]
        teamLeaders=[]
        @params[:member_ids].each do |member_id|
          resultCheckTeamMember=@teamMemberService.check_team_member(member_id)
          if resultCheckTeamMember[:errors].present?
            errors << resultCheckTeamMember[:errors]
          else
            team = ::Team.create(
              name: resultCheckTeamMember[:member].name,
              desc:  @params[:desc],
              active:  true,
              website_link:  @params[:website_link],
              organizer_id: @current_user.id,
              total_score: @params[:total_score],
              event_id: @params[:event_id]
            )
            resultTeam=team.save

            if resultTeam
              @params[:team_id]=team.id
              resultTeamMember=@teamMemberService.create_one(team.id,member_id,@params[:event_id])
              if resultTeamMember[:teamMember].present?
                  resultTeamEvent=@teamEventService.create(@params[:event_id],team.id)
                  teamLeaders << resultTeamMember[:teamMember]
                  teamEvents << resultTeamEvent[:teamEvent]
                  teams << team
              else
                errors << resultTeamMember[:errors]
              end
            else
              errors << team.errors.full_messages


            end
          end
        end
        { teams: teams,teamEvents: teamEvents, teamLeaders: teamLeaders ,errors: errors}
      end

      def create

        errors=[]
        team=nil
        resultTeamEvent=nil
        resultTeamMember=nil
        result=@teamMemberService.check_team_member(@params[:member_ids].first)
        if result[:errors].present?
          errors << result[:errors] if result[:errors].present?
          { errors: errors }
        else
          ActiveRecord::Base.transaction do
            team = ::Team.create(
              name:  @params[:name],
              desc:  @params[:desc],
              active:  @params[:active],
              website_link:  @params[:website_link],
              organizer_id: @current_user.id,
              total_score: @params[:total_score],
              event_id: @params[:event_id],
              pitching_order: @params[:pitching_order]
            )
            teamStatus=team.save
            @params[:team_id]=team.id
            resultTeamMember=@teamMemberService.create
            resultTeamEvent=@teamEventService.create(@params[:event_id],team.id)
            if !(teamStatus && resultTeamMember[:teamMembers].present? && resultTeamEvent[:teamEvent].present?)
              errors << resultTeamEvent[:errors] if team.errors.full_messages.present?
              errors << resultTeamEvent[:errors] if resultTeamEvent[:errors].present?
              raise ActiveRecord::Rollback
            end
          end
        end
        if errors.empty?
          { team: team, teamLeader: resultTeamMember[:teamMembers].first, teamEvent: resultTeamEvent[:teamEvent], tran_investor: resultTeamEvent[:tranInvestor] }
        else
          { errors: errors }
        end
      end

      private






    end
