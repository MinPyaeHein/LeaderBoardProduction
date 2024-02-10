# app/services/member_service.rb


    class Judge::CreateService
      def initialize(params)
        @params = params
      end
      def create
        result=check_judge
        if result[:errors].present?
          return result
        end
        judge = ::Judge.create(
          member_id:  @params[:member_id],  
          event_id: @params[:event_id],
          active:  @params[:active],
          current_amount:  @params[:current_amount]
        ) 
        if judge.save
          puts "success judge created successfully" 
          { judge: judge}
        else
          { errors: judge.errors.full_messages }
        end
      end
      def check_judge
        member = ::Member.find_by(id: @params[:member_id],active: true)
        unless member
          return { errors: ["Member with ID #{@params[:member_id]} does not exist in the database."] }
        end
        {}
      end

    
    end

  