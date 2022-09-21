# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :build_post, only: %i[create]
  before_action :authorize_post, only: %i[show edit update destroy]
  before_action :update_setup, only: %i[update]

  def index
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @posts = policy_scope(@user.posts.includes(:photos).order('created_at DESC'))
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    if @post.save
      flash[:notice] = t('.notice')
    else
      flash[:alert] = @post.errors.full_messages
    end
    redirect_to posts_path
  end

  def update
    redirect_to post_path
  end

  def destroy
    if @post.destroy
      flash[:notice] = t('.notice')
    else
      flash[:alert] = t('.alert')
    end
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit :description, :user_id
  end

  def build_post
    @post = current_user.posts.build(post_params)
    return unless params[:images]

    params[:images].each do |img|
      @post.photos.build(image: img)
    end
  end

  def update_setup
    ActiveRecord::Base.transaction do
      params[:images]&.each do |img|
        @post.photos.create(image: img)
      end
      if @post.update(post_params)
        flash[:notice] = t('.notice')
      else
        flash[:alert] = @post.errors.full_messages
        raise ActiveRecord::Rollback
      end
    end
  end

  def authorize_post
    authorize @post
  end
end
