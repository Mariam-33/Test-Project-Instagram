# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  before_action :collect_posts, only: %i[home]
  before_action :find_following, only: %i[collect_posts]
  def home
    redirect_to new_user_session_path unless user_signed_in?
  end

  def followers
    @followers = current_user.followers
  end

  def following
    @following = current_user.following
  end

  private

  def collect_posts
    @follows = current_user.following
    @follow_ids = @follows.pluck(:followed_id)
    @posts = []
    @follow_ids.each do |follow|
      followed = User.find(follow)
      @relationship = Relationship.find_by follower_id: current_user.id, followed_id: followed.id
      @posts = @posts << (followed.posts.includes(:photos)) if @relationship.accepted || followed.account == 'Public'
    end
  end
end
