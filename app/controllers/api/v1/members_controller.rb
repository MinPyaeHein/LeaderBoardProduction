# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class MembersController < ApplicationController
       
        skip_before_action :authenticate_request, only: [:create, :login]
        before_action :set_service, only: [:create, :destroy, :logout, :login]

        def login
          result=@loginLogout_service.login
          if result[:token].present?
            render json: { user: result[:user], member: result[:member],token: result[:token] }, status: :created
          elsif result[:error].present?
            render json: { error: result[:error] }, status: :unprocessable_entity
          end
        end
        def logout
       
          render json: { message: 'Logged out successfully' }
        end
        def index
        
          active_members = Member.includes(:users).where(active: true)
          render json: active_members, include: :users
        end

        def destroy   
          result = @destroy_service.destroy_member(params[:id])
          render json: result
        end
        def create
          result=@create_service.create_member
          
          if result[:token]
            render json: { user: result[:user], member: result[:member], token: result[:token],password: result[:password] }, status: :created
          elsif result[:errors]
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          else
            render json: { member: result[:member] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:member).permit(:email)
        end
        def login_params
          params.require(:member).permit(:email, :password)
        end
        def set_service
          
          @create_service = Member::CreateService.new(member_params)
          @destroy_service = Member::DestroyService.new(member_params)
          @loginLogout_service = Member::LoginLogoutService.new(login_params)
        end 

      end
    end
  end
  