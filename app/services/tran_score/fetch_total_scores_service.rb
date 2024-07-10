  class TranScore::FetchTotalScoresService
    def initialize(event_id)
      @event_id = event_id
    end

    def call
      teams = Team.where(event_id: @event_id)
      judges = Judge.where(event_id: @event_id)
      teams.each do |team|
        total_score = calculate_team_total_score(team, judges)
        save_team_total_score(team, total_score)
      end
      teams
    end

    private

    def calculate_team_total_score(team, judges)
      total_score = 0
      team_event = team.team_events.first
      return total_score unless team_event

      ScoreMatrix.where(event_id: @event_id).each do |score_matrix|
        judges.each do |judge|
          tran_scores = TranScore.where(
            team_event_id: team_event.id,
            score_matrix_id: score_matrix.id,
            judge_id: judge.id
          )
          total_score += tran_scores.last.score * score_matrix.weight if tran_scores.any?
        end
      end
      total_score / judges.size
    end

    def save_team_total_score(team, total_score)
      team_event = team.team_events.first
      return unless team_event

      team_event.total_score = total_score
      team_event.save
    end
  end
