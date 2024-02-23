# app/services/member_service.rb


    class TranInvestor::CreateService
      def initialize(params)
        @params = params
       
      end
  
      def create
            invest_matrix=InvestorMatrix.find_by(event_id: @params[:event_id])
            team_event=TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
            puts "invest_matrix: #{invest_matrix}"
            puts "team_event: #{team_event}"
            if !team_event.nil? && !invest_matrix.nil?
              tranInvestor= ::TranInvestor.create(
              amount: invest_matrix.one_time_pay,
              investor_matrix_id: invest_matrix.id,
              judge_id: @params[:judge_id],
              team_event_id: team_event.id,
              event_id: @params[:event_id])
              if tranInvestor.save
                judge = Judge.find_by(member_id: @params[:judge_id],event_id: @params[:event_id])

                if judge
                  if (judge.current_amount - invest_matrix.one_time_pay)<=0
                    { errors: ["Insuficient Judge Acc Balance"] }
                  else
                    new_amount = judge.current_amount - invest_matrix.one_time_pay
                    judge.update(current_amount: new_amount)
                  end
                else
                  { errors: ["Judge not exist in the database"] }
                end
                {tranInvestor:tranInvestor}
              else
                { errors: tranInvestor.errors.full_messages }
              end
            else
              { errors: ["This Team Event is not in the database...!!"] }
            end
      
        end
      
    end
  

  