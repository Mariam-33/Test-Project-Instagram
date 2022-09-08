# frozen_string_literal: true

# Like controller
class LikesController < ApplicationController
  def create
    @like = current_user.likes.create(like_params)
    @post = @like.post
    respond_to :js
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    if @like.destroy
      respond_to :js
    else
      flash[:alert] = 'Something went wrong'
    end
  end

  private

  def like_params
    params.permit(:post_id, :user_id)
  end
end
