# app/services/member_service.rb


    class Team::CreateService
      def initialize(params,current_user)
        @params = params
        @current_user = current_user
      end
  
      def create
        puts "current user ID: #{@current_user.id}"
      
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
        puts "Team Id: #{team.id}"
        puts "Leader Id: #{@params[:leader_id]}"
        teamMember = ::TeamMember.new(active: false, leader: true, member_id: @params[:leader_id],team_id: team.id)
        teamMemberStatus=teamMember.save
        if teamStatus && teamMemberStatus   
          puts "success team created successfully" 
          { team: team}
        else
          { errors: team.errors.full_messages }
        end
       
      
      end
    
    end

  