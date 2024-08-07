# app/services/member_service.rb


    class Event::CreateService
      def initialize(params,current_user)
        @current_user = current_user
        @params = params
      end

      def create

        event= ::Event.create(
                name: @params[:name],
                desc: @params[:desc],
                active: @params[:active],
                start_date: @params[:start_date],
                end_date: @params[:end_date],
                start_time: @params[:start_time],
                end_time: @params[:end_time],
                all_day: @params[:all_day],
                location: @params[:location],
                organizer_id: @current_user.member_id,
                status: @params[:status],
                event_type_id: @params[:event_type_id],
                score_type_id: @params[:score_type_id])
        if event.save
          { event: event}
        else
          { errors: event.errors.full_messages }
        end


      end

    end
