# app/services/member_service.rb


    class TranInvestor::FetchTranInvestorService
      def initialize()
      end

      def fetch_all_tran_investors_by_event_and_judge(event_id,judge_id)

          judge=Judge.find_by(member_id:judge_id)
          if judge.nil?
           return { success: false, message: {errors: "Judge Not Found in the system!!"}}
          end
          tran_investors = TranInvestor.includes(:team_event).where(event_id:event_id,judge_id:judge.id)
          serialized_tran_investors = ActiveModelSerializers::SerializableResource.new(tran_investors.sort_by(&:created_at), each_serializer: TranInvestorSerializer)
          judge = {
            id: judge.id,
            member_id: judge.member_id,
            name: judge.member.name,
            event_id: judge.event_id,
            tran_investors: serialized_tran_investors
          }

        return { success: true,message: {judge: judge}}

      end

      def fetch_invest_amounts_by_team(event_id)

        teamInvestScores = TranInvestor.group(:team_event_id, 'teams.id', 'team_events.event_id')
                                        .select('teams.id AS team_id, team_events.event_id,
                                        tran_investors.team_event_id AS team_event_id,
                                        SUM(tran_investors.amount) AS total_amount')
                                        .joins(team_event: :team)
                                        .where(team_events: { event_id: event_id })
                                        .pluck('teams.id AS team_id, teams.name AS team_name,
                                         tran_investors.team_event_id AS team_event_id,
                                         SUM(tran_investors.amount) AS total_amount,
                                         team_events.event_id,teams.pitching_order')


        teamInvestScores.map! do |team|

          {
            name: team[1],
            value: team[3],
            team_id: team[0],
            team_event_id: team[2],
            team_pitching_order: team[5],
            event_id: team[4]

          }
        end
        return {sucess: true,message: { teamInvestScores: teamInvestScores}}
        
      end

      def fetch_all_tran_investors_by_event(event_id)

        judges_origin=Judge.includes(:member).where(event_id:event_id)
        judges= []
        judges_origin.each do |judge|
          tran_investors = TranInvestor.includes(:team_event).where(event_id:event_id,judge_id:judge.id)
          serialized_tran_investors = ActiveModelSerializers::SerializableResource.new(tran_investors.sort_by(&:created_at), each_serializer: TranInvestorSerializer)
          judge = {
            id: judge.id,
            member_id: judge.member_id,
            name: judge.member.name,
            event_id: judge.event_id,
            tran_investors: serialized_tran_investors
          }
          judges << judge
        end
        return {success: true, message: {judges: judges}}


    end

  end
