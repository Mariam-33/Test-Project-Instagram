# frozen_string_literal: true

# Comment controller
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: %i[edit update destroy]

  def edit
    respond_to :js
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      @post = @comment.post
      flash[:notice] = 'Saved'
      respond_to :js
    else
      flash[:alert] = 'Comment not created'
    end
  end

  def update
    return unless @comment.user_id == current_user.id

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

  def find_comment
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end
end
