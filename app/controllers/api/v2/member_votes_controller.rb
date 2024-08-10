# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class MemberVotesController < ApplicationController
        before_action :set_service, only: [:create]
        
        def create
          result=@service.create()
          message={success: true, message: result}
          render json: message, status: :ok
        end

        private
        def vote_params
          params.require(:member_vote).permit(:team_id)
        end
        def set_service
          @service = MemberVote::CreateService.new(vote_params,@current_user)
        end
      end
    end
  end
