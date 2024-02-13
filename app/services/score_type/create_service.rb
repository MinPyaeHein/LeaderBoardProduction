# app/services/member_service.rb


    class ScoreType::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        scoreType = ::ScoreType.create(name: @params[:name], desc: @params[:desc])
        if scoreType.save
          {scoreType:scoreType}
        else
          { errors: scoreType.errors.full_messages }
        end
      
      end
    
    end

  