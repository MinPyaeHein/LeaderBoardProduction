class TranScore::FetchOneTeamScoreCategoryByIndividualJudge
  def initialize(event_id, team_id)
    @event_id = event_id
    @team_id = team_id
  end

  def get_one_team_score_category_by_individual_judge
    team = Team.find_by(event_id: @event_id, id: @team_id)
    return { success: false, error: "Team not found" } unless team

    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
    team_data[:judges] = []

    score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
    judges = Judge.where(event_id: @event_id)

    judges.each do |judge|
      score_categories = build_score_categories(team, judge, score_matrices)
      judge_name = judge.member&.name || "Unknown Judge"

      team_data[:judges] << {
        id: judge.id,
        member_id: judge.member_id,
        name: judge_name,
        score_categories: score_categories
      }
    end

    { success: true, message: { team: team_data } }
  end

  private

  def build_score_categories(team, judge, score_matrices)
    team_event = team.team_events.last
    score_matrices.map do |score_matrix|
      tran_score = TranScore.find_by(team_event_id: team_event&.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
      {
        category: score_matrix.name,
        score: tran_score&.score || 0,
        short_term: score_matrix.score_info.short_term,
        weight: score_matrix.weight
      }
    end
  end
end
