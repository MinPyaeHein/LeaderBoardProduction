# app/services/member_service.rb


    class Judge::CreateService
      def initialize(params)
        @params = params
      end
      def create
        judges=[]
        errors=[]
       
        @params[:member_ids].each do |member_id|
          result=check_judge(member_id)
        
          if result[:errors].present?
            puts "result_error: #{result[:errors]}"
            errors << result[:errors]
          else
            puts "success to save"
            judge = ::Judge.create(
              member_id:  member_id,  
              event_id: @params[:event_id],
              active:  @params[:active],
              judge_type: @params[:judge_type],
              current_amount:  @params[:current_amount]
            ) 
            if judge.save
              judges << judge
             
            else
              errors << judge.errors.full_messages
            end
          end
        end
        { judges: judges, errors: errors }
          
      end
      def check_judge(member_id)
        member = Member.includes(:users).find_by(id: member_id, active: true)
        if member.nil? 
          return { errors: ["Member does not exist in the database."] }
        end
        existing_judge = ::Judge.find_by(member_id: member_id, event_id: @params[:event_id], active: true)
        if !existing_judge.nil?
          if !member.users.first.nil?
             return { errors: ["This judge #{member.users.first.email} already part of the this Event."] }
          else
            return { errors: ["This judge already part of the this Event."] }
          end
        end
        {}
      end

    
    end

  