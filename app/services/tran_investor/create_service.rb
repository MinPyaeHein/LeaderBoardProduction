# app/services/member_service.rb


    class TranInvestor::CreateService
      def initialize(params)
        @params = params
      end
      def create
            invest_matrix=InvestorMatrix.find_by(event_id: @params[:event_id],investor_type: @params[:investor_type])
            team_event=TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
            judge = Judge.find_by(member_id: @params[:judge_id],event_id: @params[:event_id],judge_type: @params[:investor_type])

            if @params[:tran_type] == "add"

              if  judge != nil &&  (judge.current_amount - invest_matrix.one_time_pay)<0

                { errors: ["Insuficient Judge Acc Balance"] }
              else
                  if !team_event.nil? && !invest_matrix.nil? && !judge.nil?
                    tranInvestor= ::TranInvestor.create(
                    amount: invest_matrix.one_time_pay,
                    judge_id: judge.id,
                    team_event_id: team_event.id,
                    event_id: @params[:event_id])
                    if tranInvestor.save
                          new_amount = judge.current_amount - invest_matrix.one_time_pay
                          judge.update(current_amount: new_amount)
                      {tranInvestor:tranInvestor, judge:judge}
                    else

                      { errors: tranInvestor.errors.full_messages }
                    end
                  else
                    { errors: ["This Team Event is not in the database...!!"] }
                  end
              end
            elsif @params[:tran_type] == "sub"
              tran_record=TranInvestor.where(event_id: @params[:event_id], judge_id: judge.id, team_event_id: team_event.id)
              if (tran_record.sum(:amount) - invest_matrix.one_time_pay)<0
                { errors: ["You should not subtract investment amount more than you invested!!"] }
              else
                  if !team_event.nil? && !invest_matrix.nil? && !judge.nil?
                    tranInvestor= ::TranInvestor.create(
                    amount: -invest_matrix.one_time_pay,
                    judge_id: judge.id,
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
          team_event=TeamEvent.find_by(event_id: @params[:event_id], team_id: team_id)
              tranInvestor= ::TranInvestor.create(
              amount: 0.0,
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
