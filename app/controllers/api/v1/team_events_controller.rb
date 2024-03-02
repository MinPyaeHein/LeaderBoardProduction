# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TeamEventsController < ApplicationController
        # before_action :set_service, only: [:create]
        def index
          message={}
          message[:teams]=TeamEvent.all
          render json:{success: true,message: message}
        end


      end
    end
  end
  