# app/services/member_service.rb


    class Event::UpdateService
      def initialize(params,current_user)
        @params = params
        @current_user=current_user
      end

      def update
        puts("event_id=",@params[:event_id])
        @event = ::Event.find(@params[:event_id]) # Assuming you're updating an existing member
        puts("event=",@event)
        @event.assign_attributes(
          name: @params[:name],
          desc: @params[:desc],
          active: @params[:active],
          start_date: @params[:start_date],
          end_date: @params[:end_date],
          start_time: @params[:start_time],
          end_time: @params[:end_time],
          all_day: @params[:all_day],
          location: @params[:location],
          organizer_id: @current_user.id,
          status: @params[:status],
          event_type_id: @params[:event_type_id],
          score_type_id: @params[:score_type_id]
        )
        if @event.save
          { event: @event.reload } # Reload to get the latest data
        else
          { errors: @event.errors.full_messages }
        end
      end


    end
