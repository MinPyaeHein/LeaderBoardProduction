class TranScore::FetchAllTeamScoreCategoriesByJudge
  def initialize(event_id, member_id)
    @event_id = event_id
    @member_id = member_id
  end

  def call
    teams = Team.includes(:team_events).where(event_id: @event_id)
    judge = Judge.find_by(member_id: @member_id, event_id: @event_id)

    return { error: "Judge not found" } unless judge
    return { error: "Teams not found" } if teams.empty?

    get_all_team_score_categories_by_judge(teams, judge)
  end

  private

  def get_all_team_score_categories_by_judge(teams, judge)
    score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
    team_event_ids = teams.map { |team| team.team_events.first&.id }.compact
    tran_scores = TranScore.where(team_event_id: team_event_ids, judge_id: judge.id)
                           .group_by { |ts| [ts.team_event_id, ts.score_matrix_id] }

    teams_data = teams.map do |team|
      team_event = team.team_events.first
      next unless team_event

      team_data = format_score_matrix_data(team, score_matrices, tran_scores[team_event.id] || [])
      team_data
    end.compact

    { teams: teams_data }
  end

  def format_score_matrix_data(team, score_matrices, tran_scores)
    scores_by_matrix = tran_scores.index_by(&:score_matrix_id)
    weighted_scores = Hash.new(0)
    scores = Hash.new(0)

    score_matrices.each do |score_matrix|
      score = scores_by_matrix[score_matrix.id]&.score
      next unless score

      weighted_scores[score_matrix.name] = score * score_matrix.weight
      scores[score_matrix.name] = score
    end

    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
    team_data[:score_category] = score_matrices.map do |score_matrix|
      {
        category: score_matrix.name,
        weighted_scores: weighted_scores[score_matrix.name],
        scores: scores[score_matrix.name],
        short_term: score_matrix.score_info.shortTerm
      }
    end
    team_data
  end
end
