# app/services/member_service.rb


    class TeamEvent::CreateService
      def initialize(params,current_user)
        @params = params
        @tranInvestorsService=TranInvestor::CreateService.new(@params,current_user)
      end

      def create
        result=check_team_event
        if result[:errors].nil?
            teamEvent= ::TeamEvent.create(
            total_score: 0.0,
            event_id: @params[:event_id],
            team_id: @params[:team_id])
            if teamEvent.save


              {teamEvent:teamEvent}
            else
              { errors: teamEvent.errors.full_messages }
            end
        else
          result
        end

      end
      def create(event_id,team_id)
        result=check_team_event
        if result[:errors].nil?
            teamEvent= ::TeamEvent.create(
            total_score: 0.0,
            event_id: event_id,
            team_id: team_id)
            if teamEvent.save

              tranInvestor=@tranInvestorsService.create_initial_tran(event_id,team_id)
              {teamEvent:teamEvent,tranInvestor:tranInvestor}
            else
              { errors: teamEvent.errors.full_messages }
            end
        else
          result
        end

      end
      private

      def check_team_event
        team_event = ::TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
        if !team_event.nil?
          return { errors: ["This Team Event is already exist in the TeamEvent."] }
        end

        {}
      end

    end
