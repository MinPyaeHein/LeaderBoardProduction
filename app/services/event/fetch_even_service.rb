# app/services/member_service.rb


    class Event::FetchEvenService
      def initialize()

      end

      def fetch_events_by_member_id(member_id)
        member = Member.find(member_id)
        organized_events = serialize_events(member.events)
        judged_events = serialize_events(Event.joins(:judges).where(judges: { member_id: member.id }))
        team_member_events = serialize_events(Event.joins(teams: :team_members).where(team_members: { member_id: member.id }))
        edited_events = serialize_events(Event.joins(:editors).where(editors: { member_id: member.id }))

        {
          organized_events: organized_events,
          judged_events: judged_events,
          team_member_events: team_member_events,
          edited_events: edited_events
        }
      end

      def fetch_event_by_id(event_id)
        @event = Event.includes(
          :teams,
          :organizer,
          :judges,
          :editors,
          :event_type,
          :score_type,
          score_matrices: :score_info # Make sure to include score_info
        ).find(event_id)

        serialize_event = ActiveModelSerializers::SerializableResource.new(@event, serializer: EventSerializer)

        { event: serialize_event.as_json }
      end


      private
      def serialize_events(events)
        ActiveModelSerializers::SerializableResource.new(events, each_serializer: EventSerializer)
      end

    end
