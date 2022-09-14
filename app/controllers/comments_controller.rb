# frozen_string_literal: true

# Comment controller
class CommentsController < ApplicationController
  before_action :set_comment_post, only: %i[edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  def edit
    respond_to :js
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(comment_params[:post_id])
    authorize @comment
    if @comment.save
      respond_to :js
    else
      flash.now[:alert] = @comment.errors.full_messages
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to :js
    else
      @post = Post.find(comment_params[:post_id])
      flash.now[:alert] = @comment.errors.full_messages
    end
  end

  def destroy
    if @comment.destroy
      respond_to :js
    else
      flash.now[:alert] = 'Comment not destroyed'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:statement, :post_id, :user_id)
  end

  def set_comment_post
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def authorize_user
    authorize @comment
  end
end
