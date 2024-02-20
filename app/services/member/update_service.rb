# app/services/member_service.rb


    class Member::UpdateService
      def initialize(params)
        @params = params
      end 
    
      def update
        @member = ::Member.find(@params[:member_id]) # Assuming you're updating an existing member
        @member.assign_attributes(
          name: @params[:name],
          phone: @params[:phone],
          address: @params[:address], 
          desc: @params[:desc],
          faculty_id: @params[:faculty_id],
          org_name: @params[:org_name],
          profile_url: @params[:profile_url],
          active: @params[:active]
        )
      
        if @member.save
          { member: @member.reload } # Reload to get the latest data
        else
          { errors: @member.errors.full_messages }
        end
      end

   
    end

  