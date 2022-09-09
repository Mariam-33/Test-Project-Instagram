# frozen_string_literal: true

# Stories controller
class StoriesController < ApplicationController
  before_action :set_story, only: %i[show destroy]
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

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit :content, :user_id
  end

  def build_story
    @story = current_user.stories.create(story_params)
    return if params[:images].blank?

    params[:images].each do |img|
      @story.photos.create(image: img)
    end
  end
end
