# frozen_string_literal: true

# Users controller
class UsersController < ApplicationController
  def index
    @users = User.search_by_username(params[:query])
    return unless @users.empty?

    flash[:alert] = t('.alert')
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    @relationship = @user.followers.find_by(follower: current_user)
    @posts = @user.posts.includes(:photos)
    @stories = @user.stories.includes(:photos)
  end
end
