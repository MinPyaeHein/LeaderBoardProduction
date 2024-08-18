# app/services/member_service.rb


    class Event::UpdateService
      def initialize(params=nil,current_user=nil)
        @params = params
        @current_user=current_user
      end


      def update

        @event = ::Event.find(@params[:id])

        old_values = {
          name: @event.name,
          desc: @event.desc,
          active: @event.active,
          start_date: @event.start_date,
          end_date: @event.end_date,
          start_time: @event.start_time,
          end_time: @event.end_time,
          all_day: @event.all_day,
          location: @event.location,
          organizer_id: @event.organizer_id,
          event_type_id: @event.event_type_id,
          score_type_id: @event.score_type_id,
          status: @event.status
        }

        new_values = {
          name: @params[:name] || old_values[:name],
          desc: @params[:desc] || old_values[:desc],
          active: @params[:active].nil? ? old_values[:active] : @params[:active],
          start_date: @params[:start_date] || old_values[:start_date],
          end_date: @params[:end_date] || old_values[:end_date],
          start_time: @params[:start_time] || old_values[:start_time],
          end_time: @params[:end_time] || old_values[:end_time],
          all_day: @params[:all_day].nil? ? old_values[:all_day] : @params[:all_day],
          location: @params[:location] || old_values[:location],
          organizer_id: @params[:organizer_id] || old_values[:organizer_id],
          event_type_id: @params[:event_type_id] || old_values[:event_type_id],
          score_type_id: @params[:score_type_id] || old_values[:score_type_id]
        }

        @event.assign_attributes(new_values)

        if @event.save
          { event: @event.reload }
        else
          { errors: @event.errors.full_messages }
        end
      end

      def update_status(event_params)
        puts("event_params[:id]=",event_params[:id])
        event = Event.find_by(id: event_params[:id])

        return {success: false,message:{ errors: "Team does not exist in the System" }} unless  event
        if event.update(status: event_params[:status])
           return {success: true,message: {event: event }}
        else
         return {success:false,message: {error: event.errors.full_messages}}
        end
      end


      def update_event_score_type(event_id,score_type_id)
        @event = ::Event.find_by(id: event_id)
        return {success: false,message:{ errors: "Event does not exist in the System" }} unless  @event
        @event.assign_attributes(
          score_type_id: score_type_id
        )
        if @event.save
          { success: true,message: { event: @event.reload} }
        else
          {success: false,message:{errors: @event.errors.full_messages }}
        end
      end


    end
