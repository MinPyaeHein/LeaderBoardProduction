# app/services/member_service.rb


    class TranInvestor::CreateService
      def initialize(params)
        @params = params
      end
      def create
            
            invest_matrix=InvestorMatrix.find_by(event_id: @params[:event_id],investor_type: @params[:investor_type])
            team_event=TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
            judge = Judge.find_by(member_id: @params[:judge_id],event_id: @params[:event_id],judge_type: @params[:investor_type])
            puts "invest_matrix: #{invest_matrix} team_event: #{team_event} judge: #{judge}"
            puts "invest_matrix: #{invest_matrix} team_event: #{team_event} judge: #{judge}"
            puts "invest_matrix: #{invest_matrix} team_event: #{team_event} judge: #{judge}"
            if @params[:tran_type] == "add"
             
              if  judge != nil &&  (judge.current_amount - invest_matrix.one_time_pay)<0
              
                { errors: ["Insuficient Judge Acc Balance"] }
              else
                  if !team_event.nil? && !invest_matrix.nil? && !judge.nil?
                    tranInvestor= ::TranInvestor.create(
                    amount: invest_matrix.one_time_pay,
                    investor_matrix_id: invest_matrix.id,
                    judge_id: judge.id,
                    team_event_id: team_event.id,
                    event_id: @params[:event_id])
                    if tranInvestor.save
                          puts "success to save tranInvestor"
                          new_amount = judge.current_amount - invest_matrix.one_time_pay
                          puts "new_amount: #{new_amount}"
                          judge.update(current_amount: new_amount)
                          puts "success to update judge amount: #{judge.current_amount}"
                      {tranInvestor:tranInvestor, judge:judge}
                    else
                      puts "failed to add tranInvestor"
                      { errors: tranInvestor.errors.full_messages }
                    end
                  else
                    { errors: ["This Team Event is not in the database...!!"] }
                  end
              end
            elsif @params[:tran_type] == "sub"
              tran_record=TranInvestor.where(event_id: @params[:event_id], judge_id: @params[:judge_id], team_event_id: team_event.id)
              if (tran_record.sum(:amount) - invest_matrix.one_time_pay)<0
                { errors: ["You should not subtract investment amount more than you invested!!"] }
              else
                  if !team_event.nil? && !invest_matrix.nil? && !judge.nil?
                    tranInvestor= ::TranInvestor.create(
                    amount: -invest_matrix.one_time_pay,
                    investor_matrix_id: invest_matrix.id,
                    judge_id: @params[:judge_id],
                    team_event_id: team_event.id,
                    event_id: @params[:event_id])
                    if tranInvestor.save
                          new_amount = judge.current_amount + invest_matrix.one_time_pay
                          judge.update(current_amount: new_amount)
                      {tranInvestor:tranInvestor, judge:judge}
                    else
                      { errors: tranInvestor.errors.full_messages }
                    end
                  else
                    { errors: ["This Team Event is not in the database...!!"] }
                  end
              end
            end
      
        end
        def create_initailal_tran(event_id,team_id)
       
          invest_matrix=InvestorMatrix.find_by(event_id: @params[:event_id])
          puts "invest_matrix:-----------------#{invest_matrix}"
          puts "event_id:-----------------#{@params[:event_id]} team_id: #{team_id}"
          team_event=TeamEvent.find_by(event_id: @params[:event_id], team_id: team_id)
         
            # if !team_event.nil? && !invest_matrix.nil? 
              tranInvestor= ::TranInvestor.create(
              amount: 0.0,
              investor_matrix_id: invest_matrix.id,
              judge_id: 4,
              team_event_id: team_event.id,
              event_id: @params[:event_id])
              if tranInvestor.save
                {tranInvestor:tranInvestor}
              else
                { errors: tranInvestor.errors.full_messages }
              end
         
        
        end
      
    end
  

  