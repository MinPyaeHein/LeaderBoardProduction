# app/services/member_service.rb


    class ScoreInfo::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        scoreInfo = ::ScoreInfo.create(name: @params[:name], desc: @params[:desc])
        if scoreInfo.save
          {scoreInfo:scoreInfo}
        else
          { errors: scoreInfo.errors.full_messages }
        end
      
      end
    
    end

  