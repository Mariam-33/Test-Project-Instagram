# frozen_string_literal: true

# Relationships controller
class RelationshipsController < ApplicationController
  before_action :set_user, only: %i[create]
  def index
    @followers = current_user.followers
    @following = current_user.following
  end

  def create
    @rel = Relationship.new(follower_id: current_user.id, followed_id: @user.id)
    @rel.accept_request(@user)
    if @rel.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] =  t('.alert')
    end
    redirect_to user_path(@user)
  end

  def update
    @rel = Relationship.find(params[:id])
    @rel.accepted = true
    if @rel.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
    end
    redirect_to user_path(@rel.follower_id)
  end

  def destroy
    @rel = Relationship.find(params[:id])
    if @rel.destroy
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
    end
    redirect_to user_path(@rel.followed_id)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
