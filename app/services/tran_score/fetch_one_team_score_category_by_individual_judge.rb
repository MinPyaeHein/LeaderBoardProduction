class TranScore::FetchOneTeamScoreCategoryByIndividualJudge
  def initialize(event_id, team_id)
    @event_id = event_id
    @team_id = team_id
  end

  def get_one_team_score_category_by_individual_judge
    teams = Team.where(event_id: @event_id, id: @team_id)
    return { success: false, error: "Team not found" } if teams.empty?
    team = teams.last
    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
    team_data[:judges] = []
    score_matrics = ScoreMatrix.includes(:score_info).where(event_id: @event_id)

    Judge.where(event_id: @event_id).each do |judge|
      score_category = []
      score_matrics.each do |score_matrix|
        team_event = team.team_events.last
        if team_event.nil?
          score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
          next
        end

        tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
        if tran_scores.any?
          last_tran_score = tran_scores.last
          score_category << { category: score_matrix.name, score: last_tran_score.score, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
        else
          score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
        end
      end

      judge_name = judge.member&.name || "Unknown Judge"
      team_data[:judges] << { id: judge.id, member_id: judge.member_id, name: judge_name, score_categories: score_category }
    end

  return { success: true, message: { team: team_data } }
  end


end
