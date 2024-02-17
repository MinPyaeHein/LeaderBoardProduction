# app/services/member_service.rb


    class InvestorMatrix::CreateService 
      def initialize(params)
        @params = params
        @teamEventService = TeamEvent::CreateService.new(@params)
      end
  
      def create
        errors=[]
        result=check_investor_matrix
        puts "result: :::::#{result}"
        if result[:errors].nil?
          puts "Arrive Create Investor Matrix"
            investorMatrix= ::InvestorMatrix.create(
            total_amount: @params[:total_amount],
            judge_acc_amount: @params[:judge_acc_amount],
            one_time_pay: @params[:one_time_pay],
            event_id: @params[:event_id])
            if @params[:judge_acc_amount].present?
              judge_acc_amount_to_judge
            end              
            if investorMatrix.save && result[:errors].nil?   
                teams=Team.where(event_id: @params[:event_id])
                if teams.present?
                  teams.each do |team|
                    result=@teamEventService.create(@params[:event_id],team.id)
                    if result[:errors].nil? &&result[:errors].present?
                      errors << result[:errors]
                    end
                  end
                end
                {investorMatrix:investorMatrix, team_event:result[:team_event]}
            else
              if investorMatrix.errors.present?
                errors << investorMatrix.errors.full_messages
              end         
              { errors: errors}
            end
        else
          result
        end     
      end
      private
      def judge_acc_amount_to_judge
       
        judges = Judge.where(event_id: @params[:event_id], active: true)
      
        if !judges.nil? && judges.present?
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

  