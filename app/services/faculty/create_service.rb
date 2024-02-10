# app/services/member_service.rb


    class Faculty::CreateService
      def initialize(params)
        @params = params
      end
      def create
        puts @params[:name]
        puts @params[:desc]
        faculty = ::Faculty.create(name: @params[:name], desc: @params[:desc])
        if faculty.save
          { faculty: faculty}
        else
          { errors: faculty.errors.full_messages }
        end
      end
    
    end

  