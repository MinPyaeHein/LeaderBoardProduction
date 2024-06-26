# app/services/member_service.rb


    class TeamMember::CreateService
      def initialize(params)
        @params = params
      end
      def create
        teamMembers=[]
        errors=[]
        @params[:member_ids].each do |member_id|
          result=check_team_member(member_id)
          if result[:errors].present?
            errors << result[:errors]
          else
            teamMember = ::TeamMember.create(
              team_id:  @params[:team_id],
              member_id: member_id,
              event_id: @params[:event_id],
              active:  @params[:active],
              leader:  @params[:leader]
            )
            if teamMember.save
              teamMembers << teamMember
            else
              errors << teamMember.errors.full_messages
            end
          end
        end
        { teamMembers: teamMembers, errors: errors }
      end

      def create_one(team_id,member_id,event_id)
            result=check_team_member(member_id)
            return result[:errors] if result[:errors].present?
            teamMember = ::TeamMember.create(
              team_id:  team_id,
              member_id: member_id,
              event_id: event_id,
              active:  true,
              leader:  true
            )
           { teamMember: teamMember}
      end

      def check_team_member(member_id)
        member = ::Member.find_by(id: member_id, active: true)
        if member.nil?
          return { errors: ["Member does not exist in the database."] }
        end
        existing_team_member = ::TeamMember.find_by(team_id: @params[:team_id], member_id: member_id, active: true)
        if !existing_team_member.nil?
          return { errors: ["This member "+member.users.first.email+"is already part of the team."] }
        end
        member_in_another_team = ::TeamMember.find_by(member_id: member_id, event_id: @params[:event_id], active: true)
        if !member_in_another_team.nil?
          if !member.users.length.zero?
            return { errors: ["This member #{member.users.first.email} is already part of another team."] }
          else
            return { errors: ["This member is already part of another team."] }
          end
        end
        {member: member}
      end


    end
