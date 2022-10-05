# frozen_string_literal: true

# Stories controller
class StoriesController < ApplicationController
  before_action :set_story, only: %i[show destroy]
  before_action :build_story, only: %i[create]
  # before_action :authorize_story, only: %i[show destroy]
  def index
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @stories = @user.stories.includes(:photos).order('created_at DESC')
    # @stories = policy_scope(@user.stories.includes(:photos).order('created_at DESC'))
  end

  def show; end

  def new
    @story = Story.new
  end

  def create
    if @story.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] = @story.errors.full_messages
    end
    redirect_to stories_path
  end

  def destroy
    if @story.destroy
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
    end
    redirect_to stories_path
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit :content, :user_id
  end

  def build_story
    @story = current_user.stories.build(story_params)
    return unless params[:images]

    params[:images].each do |img|
      @story.photos.build(image: img)
    end
  end

  def authorize_story
    authorize @story
  end
end
