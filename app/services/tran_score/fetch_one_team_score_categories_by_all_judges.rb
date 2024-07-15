class TranScore::FetchOneTeamScoreCategoriesByAllJudges
  def initialize(event_id, team_id)
    @event_id = event_id
    @team_id = team_id
  end

  def get_one_team_score_categories_by_all_judges
    teams = Team.where(event_id: @event_id, id: @team_id)
    return { success: false, error: "Team not found" } if teams.empty?

    team = teams.last
    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
    team_data[:score_category] = []

    judges = Judge.where(event_id: @event_id)
    score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
    score_matrices.each do |score_matrix|
        weighted_score = 0
        team_event = team.team_events.last
        valid_judge_count = 0
        judges.each do |judge|
            tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
            if tran_scores.any?
              last_tran_score = tran_scores.last
              if last_tran_score && last_tran_score.score > 0
                weighted_score += last_tran_score.score * score_matrix.weight
                valid_judge_count += 1
              end
            end
          end
          score = valid_judge_count > 0 ? (weighted_score / valid_judge_count) : 0
          formatted_score = score.zero? ? 0 : score.round(2)
          team_data[:score_category] << { category: score_matrix.name, score: formatted_score, short_term: score_matrix.score_info.shortTerm }
    end
    { success: true, message: { team: team_data } }
  end

end
