# app/services/member_service.rb


    class InvestorMatrix::CreateService
      def initialize(params)
        @params = params
        @teamEventService = TeamEvent::CreateService.new(@params)
      end

      def create
        errors=[]
        result_check_investor=check_investor_matrix

        if result_check_investor[:errors].nil?

            investorMatrix= ::InvestorMatrix.create(
            total_amount: @params[:total_amount],
            judge_acc_amount: @params[:judge_acc_amount],
            one_time_pay: @params[:one_time_pay],
            investor_type: @params[:investor_type],
            event_id: @params[:event_id])
            if @params[:judge_acc_amount].present?
              judge_acc_amount_to_judge
            end
            if investorMatrix.save
                result_team_event=nil
                teams=Team.where(event_id: @params[:event_id])
                if teams.present?
                  teams.each do |team|
                    result_team_event=@teamEventService.create(@params[:event_id],team.id)
                    if result_team_event[:errors].nil? &&result_team_event[:errors].present?
                      errors << result_team_event[:errors]
                    end
                  end
                end
                {investorMatrix:investorMatrix, team_event:result_team_event[:team_event]}
            else
              if investorMatrix.errors.present?
                errors << investorMatrix.errors.full_messages
              end
              { errors: errors}
            end
        else
          result_investor_matrix
        end
      end
      private
      def judge_acc_amount_to_judge

        judges = Judge.where(event_id: @params[:event_id], active: true,judge_type: @params[:investor_type])

        if !judges.nil? && judges.present?
          judges.each do |judge|
            Judge.update(judge.id, current_amount: @params[:judge_acc_amount])

          end
        end
      end
      def check_investor_matrix
       

        {}
      end

    end
