# frozen_string_literal: true

# Users controller
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @relationship = @user.followers.find_by(follower: current_user)
    @posts = @user.posts.includes(:photos)
    @stories = @user.stories.includes(:photos)
  end

  def index
    keyword = params[:query]
    @user = User.search_by_username(keyword).first
    if @user.present?
      redirect_to user_path(@user.id)
    else
      flash[:alert] = t('.alert')
      redirect_to root_path
    end
  end
end
