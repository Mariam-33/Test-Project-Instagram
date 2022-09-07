# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :retrieve_comment, only: %i[show index]
  before_action :retrieve_like, only: %i[show index]
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
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
    return if @post

    flash[:danger] = 'Doesnt exist'
    redirect_to root_path
  end

  def retrieve_like
    @likes = Post.includes(:likes)
    @like = Like.new
  end

  def retrieve_comment
    @comments = Post.includes(:comment)
    @comment = Comment.new
  end

  def post_params
    params.require(:post).permit :description, :user_id
  end

  def build_post
    @post = current_user.posts.build(post_params)
    return unless @post.save && params[:images].present?

    params[:images].each do |img|
      @post.photos.create(image: img)
    end
  end

  def update_setup
    @post.photos.delete_all
    if params[:images] && params[:images].length < 10
      params[:images].each do |img|
        @post.photos.create(image: img)
      end
    else
      flash[:alert] = 'Cannot attach more than 10 images'
    end
  end
end
