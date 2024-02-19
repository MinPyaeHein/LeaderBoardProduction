# app/services/member_service.rb


    class Team::CreateService
      def initialize(params,current_user)
        @params = params
        @current_user = current_user
        @teamMemberService = TeamMember::CreateService.new(params)
      end

      def createTeamWithLeaders  
        errors=[]
        teams=[]
        @params[:member_ids].each do |member_id|
          result=@teamMemberService.check_team_member(member_id)
          if result[:errors].present?
            errors << result[:errors]
          else
            team = ::Team.create(
              name: result[:member].name,
              desc:  @params[:desc],
              active:  false,
              website_link:  @params[:website_link],
              organizer_id: @current_user.id,
              total_score: @params[:total_score],
              event_id: @params[:event_id]
            )
            teamStatus=team.save
            @params[:team_id]=team.id
            result=@teamMemberService.create()
            if teamStatus && result[:teamMembers].present?
              teams << team
            elsif result[:errors].present?
              errors = team.errors.full_messages
              errors << result[:errors] 
           
            end
          end
        end
        { teams: teams, errors: errors}
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
          puts "success team created successfully" 
          { team: team}
        else
          errors = team.errors.full_messages
          errors << result[:errors] if result[:errors].present?
         { errors: errors.flatten }
        end
      end

      
       
      
  
    
    end

  