# frozen_string_literal: true

# Relationships controller
class RelationshipsController < ApplicationController
  def index
    @followers = current_user.followers
    @following = current_user.following
  end

  def create
    other_user = User.find(params[:user_id])
    @rel = Relationship.new(follower_id: current_user.id, followed_id: other_user.id)
    @rel.save
    redirect_to user_path(other_user)
  end

  def destroy
    @rel = Relationship.find(params[:id])
    @rel.destroy
    redirect_to user_path(@rel.followed_id)
  end
end
