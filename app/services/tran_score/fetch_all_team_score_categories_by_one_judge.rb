class TranScore::FetchAllTeamScoreCategoriesByOneJudge
  def initialize(event_id, member_id)
    @event_id = event_id
    @member_id = member_id
  end

  def call
    teams = Team.includes(:team_events).where(event_id: @event_id)
    judge = Judge.find_by(member_id: @member_id, event_id: @event_id)

    get_all_team_score_categories_by_judge(teams, judge)
  end
  private

  def get_all_team_score_categories_by_judge(teams, judge)
    return { error: "Teams not found" } if teams.empty?
    return { error: "Judge not found" } if judge.nil?

    score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
    teams_data = teams.map { |team| build_team_data(team, judge, score_matrices) }.compact

    { teams: teams_data }
  end

  def build_team_data(team, judge, score_matrices)
    team_event = team.team_events.first
    return nil if team_event.nil?
    weighted_scores = {}
    scores = {}
    score_matrices.each do |score_matrix|
      tran_score = TranScore.where(
        team_event_id: team_event.id,
        score_matrix_id: score_matrix.id,
        judge_id: judge.id
      ).order(created_at: :desc).last
      next unless tran_score
      weighted_scores[score_matrix.name] = tran_score.score * score_matrix.weight
      scores[score_matrix.name] = tran_score.score
    end
    format_score_matrix_data(team, score_matrices, weighted_scores, scores)
  end

  def format_score_matrix_data(team, score_matrices, weighted_scores, scores)
    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
    team_data[:score_category] = score_matrices.map do |score_matrix|
      {
        category: score_matrix.name,
        weighted_scores: weighted_scores[score_matrix.name],
        scores: scores[score_matrix.name],
        short_term: score_matrix.score_info.short_term
      }
    end
    team_data
  end
end
