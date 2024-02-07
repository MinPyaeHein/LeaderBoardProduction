# app/services/member_service.rb


    class Event::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        puts "creating event type!!"
        puts @params[:name]
        puts @params[:desc]
        event= ::Event.create(name: @params[:name], desc: @params[:desc], active: @params[:active], event_type_id: @params[:event_type_id])
        return event unless event.persisted?
        event
      
      end
    
    end

  