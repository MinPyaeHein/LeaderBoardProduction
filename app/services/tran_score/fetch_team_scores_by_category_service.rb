  class TranScore::FetchTeamScoresByCategoryService
    def initialize(event_id)
      @event_id = event_id
    end

    def call
      teams = Team.where(event_id: @event_id)
      teams.map { |team| team_score_by_category(team) }
    end

    private

    def team_score_by_category(team)
      weighted_scores = Hash.new(0)
      team_event = team.team_events.first
      judges = Judge.where(event_id: @event_id)
      judge_count = 0
      judges.each do |judge|
        total_score_judge = 0
        score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
        score_matrices.each do |score_matrix|
          tran_scores = TranScore.where(
            team_event_id: team_event.id,
            score_matrix_id: score_matrix.id,
            judge_id: judge.id
          )
          if tran_scores.any?
            last_tran_score = tran_scores.last
            weighted_scores[score_matrix.name] += last_tran_score.score * score_matrix.weight
            total_score_judge += last_tran_score.score * score_matrix.weight
          end
        end
        judge_count += 1 if total_score_judge.zero?
      end

      format_team_data(team, weighted_scores, judge_count, judges.length)
    end

    def format_team_data(team, weighted_scores, judge_count, judge_length)
      team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
      total_score = 0
      score_matrices = ScoreMatrix.includes(:score_info).where(event_id: @event_id)
      team_data[:score_category] = score_matrices.map do |score_matrix|
        score = (judge_length - judge_count) > 0 ? (weighted_scores[score_matrix.name] / (judge_length - judge_count)) : 0
        formatted_score = score.zero? ? 0 : score.round(2)
        total_score += formatted_score
        {
          category: score_matrix.name,
          short_term: score_matrix.score_info.shortTerm,
          score: formatted_score
        }
      end
      team_data[:total_score] = total_score.round(2)
      team_data
    end
  end

