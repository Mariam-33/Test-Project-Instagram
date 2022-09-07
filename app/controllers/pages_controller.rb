# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  def home
    if current_user
      @follows = current_user.following
      @follow_ids = @follows.pluck(:followed_id)
      @posts = []
      @follow_ids.each do |follow|
        follower = User.find(follow)
        @posts = @posts << (follower.posts.includes(:photos))
      end
    end
    redirect_to new_user_session_path unless user_signed_in?
  end

  def followers
    @followers = current_user.followers
  end

  def following
    @following = current_user.following
  end
end
