# frozen_string_literal: true

# Stories controller
class StoriesController < ApplicationController
  before_action :set_story, only: %i[show destroy]
  before_action :build_story, only: %i[create]
  before_action :authorize_user, only: %i[show destroy]
  def index
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @stories = @user.stories.all.includes(:photos)
    authorize @stories
  end

  def show; end

  def new
    @story = Story.new
  end

  def create
    if @story.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
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
    ActiveRecord::Base.transaction do
      @story = current_user.stories.build(story_params)
      raise ActiveRecord::Rollback unless params[:images]

      params[:images].each do |img|
        @story.photos.build(image: img)
      end
    end
  end

  def authorize_user
    authorize @story
  end
end
