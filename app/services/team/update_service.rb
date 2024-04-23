# app/services/member_service.rb


    class Team::UpdateService
      def initialize(params)
        @params = params
      end

      def update
        @team = ::Team.find(@params[:team_id])
        @team.assign_attributes(
          name:  @params[:name],
          desc:  @params[:desc],
          active:  @params[:active],
          website_link:  @params[:website_link],
          total_score: @params[:total_score],
          event_id: @params[:event_id],
          pitching_order: @params[:pitching_order]
        )

        if @team.save
          { team: @team.reload }
        else
          { errors: @team.errors.full_messages }
        end
      end


    end
