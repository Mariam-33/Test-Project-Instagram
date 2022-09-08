# frozen_string_literal: true

# Comment controller
class CommentsController < ApplicationController
  before_action :find_comment_post, only: %i[edit update destroy]
  before_action :authorize_user, only: %i[update destroy]
  def edit
    respond_to :js
  end

  def create
    @comment = current_user.comments.create(comment_params)
    @post = @comment.post
    respond_to :js
  end

  def update
    if @comment.update(comment_params)
      respond_to :js
    else
      flash[:alert] = 'Something worng, try again'
      render post_path
    end
  end

  def destroy
    if @comment.destroy
      respond_to :js
    else
      flash[:alert] = 'Comment not destroyed'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:statement, :post_id, :user_id)
  end

  def find_comment_post
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def authorize_user
    authorize @comment
  end
end
