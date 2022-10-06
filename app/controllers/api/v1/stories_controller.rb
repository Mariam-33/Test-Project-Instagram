# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      skip_before_action :authenticate_user!
      def index
        if Story.exists?
          @stories = Story.all.includes(:photos, :user)
          render json: @stories, include: %w[photos user]
        else
          render json: :null, status: :not_found
        end
      end

      def show
        if Story.exists?(params[:id])
          @story = Story.includes(:photos, :user).find(params[:id])
          render json: @story, include: %w[photos user]
        else
          render json: :null, status: :not_found
        end
      end
    end
  end
end
