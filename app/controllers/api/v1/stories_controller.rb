# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      skip_before_action :authenticate_user!
      def index
        @stories = Story.all.includes(:photos, :user)
        render json: @stories, include: %w[photos user]
      end

      def show
        @story = Story.includes(:photos, :user).find(params[:id])
        render json: @story, include: %w[photos user]
      end
    end
  end
end
