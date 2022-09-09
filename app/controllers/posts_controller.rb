# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :build_post, only: %i[create]
  before_action :update_setup, only: %i[update]
  def index
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @posts = @user.posts.all.includes(:photos).order('created_at DESC')
    @post = Post.new
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    if @post.valid?
      flash[:notice] = 'Saved'
    else
      flash[:notice] = @post.errors.full_messages
      @post.destroy
    end
    redirect_to posts_path
  end

  def update
    if @post.valid?
      redirect_to(post_url(@post), notice: 'Post was successfully updated.')
    else
      flash[:notice] = @post.errors.full_messages
      @post.destroy
      redirect_to posts_path
    end
  end

  def destroy
    @post.destroy
    redirect_to(posts_path, notice: 'Post was successfully destroyed.')
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit :description, :user_id
  end

  def build_post
    @post = current_user.posts.create(post_params)
    return if params[:images].blank?

    params[:images].each do |img|
      @post.photos.create(image: img)
    end
  end

  def update_setup
    @post.photos.delete_all
    @post.update(post_params)
    return if params[:images].blank?

    params[:images].each do |img|
      @post.photos.create(image: img)
    end
  end
end
