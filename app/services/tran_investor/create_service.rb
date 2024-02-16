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
              team_event_id: team_event.id)
              if tranInvestor.save
                judge = Judge.find_by(member_id: @params[:judge_id])

                if judge
                  puts "judge:::::: #{judge.current_amount}"
                  puts "invest_matrix.one_time_pay: #{invest_matrix.one_time_pay}"
                  new_amount = judge.current_amount - invest_matrix.one_time_pay
                  puts "new_amount: #{new_amount}"
                  judge.update(current_amount: new_amount)
                  puts "judge.current_amount: #{judge.current_amount}"
                  puts "errors #{judge.errors.full_messages}"
                else
                  puts "judge not found"
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
  

  