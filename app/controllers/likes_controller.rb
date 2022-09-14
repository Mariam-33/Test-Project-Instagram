# frozen_string_literal: true

# Like controller
class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    authorize @like
    if @like.save
      @post = @like.post
      respond_to :js
    else
      redirect_to(post_path, alert: t('.alert'))
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    authorize @like
    if @like.destroy
      respond_to :js
    else
      flash[:alert] = t('.alert')
    end
  end

  private

  def like_params
    params.permit(:post_id, :user_id)
  end
end
