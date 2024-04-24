# app/services/member_service.rb


    class ScoreMatrix::CreateService
      def initialize(score_matrics)
        @score_matrics = score_matrics

      end

      def createScoreMatrics
        score_matrics=[]
          for score_matric in @score_matrics

            score_matric=create(score_matric)
            score_matrics << score_matric
          end
        score_matrics
      end

      def create(score_matrix)
        score_info = ::ScoreInfo.find_by(name: score_matrix["name"])
        if !score_info
            score_info = ::ScoreInfo.create(name: score_matrix["name"], desc: score_matrix["desc"])
            if !score_info.save
              { errors: score_info.errors.full_messages }
            end
        end
        result=check_score_matrix(score_matrix,score_info)
        if result[:errors].nil?
            scoreMatrix= ::ScoreMatrix.create(
            weight: score_matrix["weight"],
            min: score_matrix["min"],
            max: score_matrix["max"],
            event_id: score_matrix["event_id"],
            name: score_matric["name"],
            score_info_id: score_info.id)
            if scoreMatrix.save
              {scoreMatrix:scoreMatrix,scoreInfo:score_info}
            else
              { errors: scoreMatrix.errors.full_messages }
            end
        else
          result
        end

      end
      private

      def check_score_matrix(score_matrix,score_info)
        score_matrix = ::ScoreMatrix.find_by(event_id: score_matrix["event_id"], score_info_id: score_info.id)
        if !score_matrix.nil?
          return { errors: ["This Score Matrix is already exist in the event."]}
        end
        {}
      end

    end
