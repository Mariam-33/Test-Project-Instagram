# frozen_string_literal: true

# Stories controller
class StoriesController < ApplicationController
  before_action :find_story, only: %i[show destroy]
  before_action :authenticate_user!
  before_action :build_story, only: %i[create]
  def index
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @stories = @user.stories.all.includes(:photos)
  end

  def show; end

  def new
    @story = Story.new
  end

  def create
    if @story.save
      flash[:notice] = 'Story saved'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to stories_path
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_story
    @story = Story.find(params[:id])
    return if @story

    flash[:danger] = 'Doesnt exist'
    redirect_to root_path
  end

  def story_params
    params.require(:story).permit :content, :user_id
  end

  def build_story
    @story = current_user.stories.build(story_params)
    return unless @story.save

    DeleteStoryJob.set(wait: 24.hours).perform_later(@story)
    return if params[:images].blank?

    params[:images].each do |img|
      @story.photos.create(image: img)
    end
  end
end
