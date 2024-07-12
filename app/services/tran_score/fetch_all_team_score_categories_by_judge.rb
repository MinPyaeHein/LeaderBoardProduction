class TranScore::FetchAllTeamScoreCategoriesByJudge
  def initialize(event_id,member_id)
    @event_id = event_id
    @member_id=member_id
  end

  def call
    teams = Team.where(event_id: @event_id)
    judge = Judge.where(member_id: @member_id, event_id: @event_id)
    getAllTeamScoreCategoriesByJudge(teams,judge)
    # teams.map { |team| team_score_by_category(team) }
  end

  private

  def getAllTeamScoreCategoriesByJudge(teams,judge)

    if teams.empty?
       return { error: "Teams not found" }
    end

    if judge.empty?
       return { error: "Judge not found" }
    end

    teams_data = []
    score_matrics = ScoreMatrix.includes(:score_info).where(event_id: @event_id)

    teams.each do |team|
      team_event = team.team_events.first
      next if team_event.nil?

      weighted_scores = Hash.new(0)
      scores = Hash.new(0)

      score_matrics.each do |score_matrix|
        tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.last.id)

        if tran_scores.any?
          last_tran_score = tran_scores.last
          weighted_scores[score_matrix.name] = last_tran_score.score * score_matrix.weight
          scores[score_matrix.name] = last_tran_score.score
        end
      end

      team_data = format_score_matrix_data(team,score_matrics,weighted_scores,scores)
      teams_data << team_data
    end
    return {teams:teams_data}
  end

  def format_score_matrix_data(team,score_matrics,weighted_scores,scores)
    team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
    team_data[:score_category] = score_matrics.map do |score_matrix|
      {
      category: score_matrix.name,
      weighted_scores: weighted_scores[score_matrix.name],
      scores: scores[score_matrix.name],
      short_term: score_matrix.score_info.shortTerm
    }
    end
    team_data
  end

  def validate_team_event()

  end

end
