# app/services/member_service.rb


    class TranScore::CreateService
      def initialize(params,current_user)
        @params = params
        @current_user=current_user
      end


      def create
        team_event = TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
        return { errors: "Team Event does not exist in the database" } unless team_event
        judge = Judge.find_by(member_id: @current_user.member_id, event_id: @params[:event_id])
        return { errors: "Judge does not exist in this event" } unless judge
        tran_scores = []
        errors = []

        @params[:tran_score].each do |score_params|
          score_matrix = ScoreMatrix.find_by(event_id: @params[:event_id], id: score_params[:score_matrix_id])
          if score_matrix.nil?
            errors << "Score Matrix with ID #{score_params[:score_matrix_id]} does not exist in this event"
            next
          end
          tran_score = TranScore.new(
            score: score_params[:score],
            desc: score_params[:desc],
            score_matrix_id: score_matrix.id,
            judge_id: @current_user.member_id,
            team_event_id: team_event.id,
            event_id: @params[:event_id]
          )
          if tran_score.save
            tran_score_data = tran_score.as_json
            tran_score_data[:team_id] = @params[:team_id]
            tran_scores << tran_score_data
          else
            errors.concat(tran_score.errors.full_messages)
          end
        end

        if errors.empty?
          { tranScores: tran_scores }
        else
          { errors: errors }
        end
      end
      def check_tran_score
        !TranScore.find_by(score_matrix_id: @score_matrix.id, judge_id: @params[:judge_id])
      end

    end
