# app/services/member_service.rb


    class ScoreMatrix::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        result=check_score_matrix
        if result[:errors].nil?
            scoreMatrix= ::ScoreMatrix.create(
            weight: @params[:weight],
            min: @params[:min],
            max: @params[:max],
            event_id: @params[:event_id],
            score_info_id: @params[:score_info_id])
            if scoreMatrix.save
              {scoreMatrix:scoreMatrix}
            else
              { errors: scoreMatrix.errors.full_messages }
            end
        else
          result
        end
      
      end
      private
      
      def check_score_matrix
        score_matrix = ::ScoreMatrix.find_by(event_id: @params[:event_id], score_info_id: @params[:score_info_id])
        if !score_matrix.nil? 
          return { errors: ["This Score Matrix is already exist in the event."] }
        end
        
        {}
      end
    
    end

  