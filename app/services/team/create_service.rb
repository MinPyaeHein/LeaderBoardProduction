# app/services/member_service.rb


    class Team::CreateService
      def initialize(params,current_user)
        @params = params
        @current_user = current_user
        @teamMemberService = TeamMember::CreateService.new(params)
      end
  
      def create  
        result=@teamMemberService.check_team_member
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
        if teamStatus && result[:teamMember].present?
          puts "success team created successfully" 
          { team: team}
        else
          errors = team.errors.full_messages
          errors << result[:errors] if result[:errors].present?
         { errors: errors.flatten }
        end
      end
       
      
  
    
    end

  