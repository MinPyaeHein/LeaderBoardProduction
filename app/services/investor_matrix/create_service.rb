# app/services/member_service.rb


    class InvestorMatrix::CreateService
      def initialize(params)
        @params = params
      end
  
      def create
        result=check_investor_matrix
        if result[:errors].nil?
            investorMatrix= ::InvestorMatrix.create(
            total_amount: @params[:total_amount],
            judge_acc_amount: @params[:judge_acc_amount],
            one_time_pay: @params[:one_time_pay],
            event_id: @params[:event_id])
            if @params[:judge_acc_amount].present?
              judge_acc_amount_to_judge
            end
            if investorMatrix.save
              {investorMatrix:investorMatrix}
            else
              { errors: investorMatrix.errors.full_messages }
            end
        else
          result
        end
      
      end
      private
      def judge_acc_amount_to_judge
        judges = Judge.where(event_id: @params[:event_id], active: true)

        if judges.present?
          judges.each do |judge|
            Judge.update(judge.id, current_amount: @params[:judge_acc_amount])
          end
        end
      end
      def check_investor_matrix
        score_matrix = ::InvestorMatrix.find_by(event_id: @params[:event_id])
        if !score_matrix.nil? 
          return { errors: ["This Investor Matrix is already exist in the event."] }
        end
        
        {}
      end
    
    end

  