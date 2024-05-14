# app/services/member_service.rb


    class TranScore::CreateService
      def initialize(params)
        @params = params
      end
      def create
        team_event = TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
        return { errors: "Team Event does not exist in the database" } unless team_event

        judge = Judge.find_by(member_id: @params[:judge_id], event_id: @params[:event_id])
        return { errors: "Judge does not exist in this event" } unless judge

        scoreMatrix = ScoreMatrix.find_by(event_id: @params[:event_id], id: @params[:score_matrix_id])
        return { errors: "This Score Matrix does not exist in this event" } unless scoreMatrix


        tran_score= ::TranScore.create(
          score:  @params[:score],
          desc:  @params[:desc],
          score_matrix_id:  scoreMatrix.id,
          judge_id:  judge.id,
          team_event_id: team_event.id,
          event_id: @params[:event_id]
        )
        if tran_score.save
           {tranScore: tran_score}
        else
           { errors: tran_score.errors.full_messages }
        end
      end

      def check_tran_score
        !TranScore.find_by(score_matrix_id: @score_matrix.id, judge_id: @params[:judge_id])
      end



    end
