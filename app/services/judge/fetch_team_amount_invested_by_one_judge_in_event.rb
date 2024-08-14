# app/services/member_service.rb


    class Judge::FetchTeamAmountInvestedByOneJudgeInEvent
      def initialize(member_id,event_id)
        @member_id =member_id
        @event_id=event_id
      end
      def perform

        judge = Judge.find_by(member_id: @member_id, event_id: @event_id)

        return render json: { success: false, message: "Judge not found" } if judge.nil?

        # Fetch team investment scores in a single query
        team_invest_scores = TranInvestor
          .select('teams.id AS team_id, teams.name AS team_name, team_events.event_id, teams.pitching_order, COALESCE(SUM(tran_investors.amount), 0) AS total_amount')
          .joins(team_event: :team)
          .where(team_events: { event_id: @event_id }, tran_investors: { judge_id: judge.id })
          .group('teams.id, team_events.event_id, teams.pitching_order')
          .order('teams.name')

        # Get existing teams for the event
        existing_teams = Team
          .joins(:team_events)
          .where(team_events: { event_id: @event_id })
          .pluck(:id, :name, :pitching_order)

        # Convert existing teams to a hash for easy lookup
        existing_teams_hash = existing_teams.to_h { |team_id, team_name, pitching_order| [team_id, { team_id: team_id, name: team_name, amount: 0, event_id: @event_id, pitching_order: pitching_order }] }

        # Update existing teams with scores
        team_invest_scores.each do |team|
          existing_teams_hash[team.team_id] = {
            team_id: team.team_id,
            name: team.team_name,
            amount: team.total_amount,
            event_id: team.event_id,
            pitching_order: team.pitching_order
          }

      end
      message = {
        judge: judge,
        member: Member.find(@member_id),
        teamInvestScores: existing_teams_hash.values.sort_by { |team| team[:name] }
      }
      message
    end



    end
