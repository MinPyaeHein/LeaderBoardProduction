# app/services/member_service.rb


    class Team::UpdateService
      def initialize(params=nil)
        @params = params
      end

      def update
        @team = ::Team.find_by(id: @params[:id])
        return { error: "Team does not exist in the database" } unless @team
        @team.assign_attributes(
          name:  @params[:name],
          desc:  @params[:desc],
          active:  @params[:active],
          website_link:  @params[:website_link],
          total_score: @params[:total_score],
          pitching_order: @params[:pitching_order]
        )

        if @team.save
          { team: @team.reload }
        else
          { error: @team.errors.full_messages }
        end
      end
      def update_status(team)
        @team = ::Team.find_by(id: team[:id])
        return { error: "Team does not exist in the database" } unless @team
        @team.assign_attributes(
          status:  @team[:status],
        )
        if @team.save
          { team: @team.reload }
        else
          { error: @team.errors.full_messages }
        end
      end



    end
