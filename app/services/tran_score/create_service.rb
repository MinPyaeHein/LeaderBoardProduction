class TranScore::CreateService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def create
    team_event = find_team_event
    return { errors: "Team Event does not exist in the database" } unless team_event

    judge = find_judge
    return { errors: "Judge does not exist in this event" } unless judge

    tran_scores, errors = process_tran_scores(team_event, judge)

    errors.empty? ? { tranScores: tran_scores } : { errors: errors }
  end

  private

  def find_team_event
    TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
  end

  def find_judge
    Judge.find_by(member_id: @current_user.member_id, event_id: @params[:event_id])
  end

  def process_tran_scores(team_event, judge)
    tran_scores = []
    errors = []

    @params[:tran_score].each do |score_params|
      score_matrix = find_score_matrix(score_params[:score_matrix_id])
      if score_matrix.nil?
        errors << "Score Matrix with ID #{score_params[:score_matrix_id]} does not exist in this event"
        next
      end

      tran_score = build_tran_score(score_params, score_matrix, judge, team_event)
      if tran_score.save
        tran_scores << build_tran_score_data(tran_score)
      else
        errors.concat(tran_score.errors.full_messages)
      end
    end

    [tran_scores, errors]
  end

  def find_score_matrix(score_matrix_id)
    ScoreMatrix.find_by(event_id: @params[:event_id], id: score_matrix_id)
  end

  def build_tran_score(score_params, score_matrix, judge, team_event)
    TranScore.new(
      score: score_params[:score],
      desc: score_params[:desc],
      score_matrix_id: score_matrix.id,
      judge_id: judge.id,
      team_event_id: team_event.id,
      event_id: @params[:event_id]
    )
  end

  def build_tran_score_data(tran_score)
    tran_score_data = tran_score.as_json
    tran_score_data[:team_id] = @params[:team_id]
    tran_score_data
  end

  def check_tran_score
    !TranScore.exists?(score_matrix_id: @score_matrix.id, judge_id: @params[:judge_id])
  end
end
