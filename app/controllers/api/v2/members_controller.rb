# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class MembersController < ApplicationController
        skip_before_action :authenticate_request, only: [:create, :login,:gest_login,:get_member_by_id ]
        before_action :set_service, only: [:create, :login, :update, :gest_login]
        def score_boards
          render 'score_cards/home'
        end
        def login

          result=@loginLogout_service.login
          message={}
          if result[:user].present?
            message[:user]=result[:user]
            message[:token]=result[:token]
            message[:member]=result[:member]
            render json: {success: true,message:message}, status: :ok
          else
            message[:success]=false
            message[:errors]=result[:errors]
            render json: message, status: :unprocessable_entity
          end
        end

          def gest_login
            result=@loginLogout_service.gest_login
            message={}
            if result[:user].present?
              message[:user]=result[:user]
              message[:token]=result[:token]
              message[:member]=result[:member]
              render json: {success: true,message:message}, status: :ok
            else
              message[:success]=false
              message[:errors]=result[:errors]
              render json: message, status: :unprocessable_entity
            end

        end

        def logout
          render json: { message: 'Logged out successfully' }
        end
        def index

          active_members = Member.includes(:users).where(active: true)
          message ={members: active_members}
          render json: {success: true,message: message}, status: :ok
        end
       def reset_all
        if Member.destroy_all
          render json: {success: true,message: "All members successfully deleted."}, status: :ok
        else
          render json: {success: false,message: "Failed to delete all members."}, status: :unprocessable_entity
        end
      end

      def get_member_by_id
        @member = Member.find_by(id: params[:member_id])
        if @member.nil?

          render json: { success: false, message: {errors: "Member not found in the system!!!"} }, status: :not_found
          return
        end
        @user = @member.users.first
        @token = @user.generate_jwt
        message = {
          member: @member,
          user: @user,
          token: @token
        }
        render json: { success: true, message: message }
      end
      def update
        result=@update_service.update
        message={}
        message[:member] = result[:member]
        render json: {success: true,message: message}, status: :ok
      end
      def update_member_status
        member=params.require(:member).permit(:status,:id)
        @member = Member.new(member)
        authorize @member
        @update_service= Member::UpdateService.new
        message=@update_service.update_status(@member)
        render json: message, status: :ok
      end

      def create

        result=@create_service.create_member
        message={}
        if result[:token]
          message[:token]=result[:token]
          message[:password]=result[:password]
          message[:user]=result[:user]
          message[:member]=result[:member]
          message[:success]=true
          render json: {success: true,message: message}, status: :ok
        elsif result[:errors]
          message[:success]=false
          message[:errors]=result[:errors]
          render json: message, status: :unprocessable_entity
        else
          message[:errors]=result[:errors]
          render json: result[:errors], status: :unprocessable_entity
        end
      end



        private
        def member_params
          params.require(:member).permit(:member_id,:name,:email,:password,:phone,:password,:active,:profile_url,:address,:role,:faculty_id,:org_name, :desc)
        end

        def set_service

          @create_service = Member::CreateService.new(member_params)
          @update_service = Member::UpdateService.new(member_params)
          @loginLogout_service = Member::LoginLogoutService.new(member_params)

        end


      end
    end
  end
