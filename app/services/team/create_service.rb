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
              resultTeamMember=@teamMemberService.create()
              if resultTeamMember[:teamMembers].present?
                  resultTeamEvent=@teamEventService.create(@params[:event_id],team.id)
                  teamLeaders << resultTeamMember[:teamMembers]
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
        puts "params first:::: #{@params[:member_ids].first}"
        result=@teamMemberService.check_team_member(@params[:member_ids].first)
        if result[:errors].present?
          return result
        end
        team = ::Team.create(
          name:  @params[:name],
          desc:  @params[:desc],
          active:  @params[:active],
          website_link:  @params[:website_link],
          organizer_id: @current_user.id,
          total_score: @params[:total_score],
          event_id: @params[:event_id]
        )
        teamStatus=team.save
        @params[:team_id]=team.id
        result=@teamMemberService.create()
        if teamStatus && result[:teamMembers].present?
          result=@teamEventService.create(@params[:event_id],team.id)
          puts "success team created successfully" 
          { team: team, teamLeader: result[:teamMembers].first, teamEvent: result[:teamEvent]}
        else
          errors << team.errors.full_messages
          errors << result[:errors] if result[:errors].present?
         { errors: errors.flatten }
        end
      end

      private
     

       
      
  
    
    end

  