
    class ScoreBoardsController < ApplicationController
      skip_before_action :authenticate_request, only: [:show, :home]
      def show
        render :home
      end
      def home
        puts "Arrive to home method of controller"
        render 'score_boards/home'
      end
    end
  