# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < ApplicationController
      skip_before_action :authenticate_user!
      def index
        @relationship = User.first.followers
        @followers = User.where(id: @relationship.pluck(:follower_id))
        render json: @followers
      end
    end
  end
end
