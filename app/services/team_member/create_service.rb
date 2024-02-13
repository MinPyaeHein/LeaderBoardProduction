# app/services/member_service.rb


    class TeamMember::CreateService
      def initialize(params)
        @params = params
       
      end
      def create
        result=check_team_member
        if result[:errors].present?
          return result
        end
        teamMember = ::TeamMember.create(
          team_id:  @params[:team_id],
          member_id:  @params[:member_id],  
          event_id: @params[:event_id],
          active:  @params[:active],
          leader:  @params[:leader]
        )
       
    
       
        if teamMember.save
          puts "success teamMember created successfully" 
          { teamMember: teamMember}
        else
          { errors: teamMember.errors.full_messages }
        end
      end
      def check_team_member
        member = ::Member.find_by(id: @params[:member_id], active: true)
        if member.nil? 
          return { errors: ["Member does not exist in the database."] }
        end
        existing_team_member = ::TeamMember.find_by(team_id: @params[:team_id], member_id: @params[:member_id], active: true)
        if !existing_team_member.nil?
          return { errors: ["This member is already part of the team."] }
        end
      
        member_in_another_team = ::TeamMember.find_by(member_id: @params[:member_id], event_id: @params[:event_id], active: true)
        if !member_in_another_team.nil?
          return { errors: ["This member is already part of another team."] }
        end
        {}
      end

    
    end

  