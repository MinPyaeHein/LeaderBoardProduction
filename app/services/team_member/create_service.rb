# app/services/member_service.rb


    class TeamMember::CreateService
      def initialize(params)
        @params = params
       
      end
      def create
        teamMember = ::TeamMember.create(
          team_id:  @params[:team_id],
          member_id:  @params[:member_id],  
          event_id: @params[:event_id],
          active:  @params[:active],
          leader:  @params[:leader]
        )
       
        puts "Team Id: #{@params[:team_id]}"
        puts "member Id: #{@params[:member_id]}"
       
        if teamMember.save
          puts "success teamMember created successfully" 
          { teamMember: teamMember}
        else
          { errors: teamMember.errors.full_messages }
        end
      end
    
    end

  