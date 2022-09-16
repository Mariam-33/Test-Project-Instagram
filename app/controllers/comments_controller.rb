# frozen_string_literal: true

# Comment controller
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment, only: %i[edit update destroy]
  def edit
    respond_to :js
  end

  def create
    @comment = current_user.comments.build(comment_params)
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

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_comment
    authorize @comment
  end
end
