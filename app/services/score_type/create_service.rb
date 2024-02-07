# app/services/member_service.rb


    class ScoreType::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        
        scoreType = ::ScoreType.create(name: @params[:name], desc: @params[:desc])
        return scoreType unless scoreType.persisted?
        scoreType
      
      end
    
    end

  