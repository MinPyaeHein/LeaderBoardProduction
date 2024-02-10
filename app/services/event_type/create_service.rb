# app/services/member_service.rb


    class EventType::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        puts @params[:name]
        puts @params[:desc]
        eventType = ::EventType.create(name: @params[:name], desc: @params[:desc])
        return eventType unless eventType.persisted?
        eventType
      
      end
    
    end

  