# frozen_string_literal: true

# Like controller
class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.build(like_params)
    if @like.save
      @post = @like.post
      flash[:notice] = 'Post liked'
      respond_to :js
    else
      flash[:alert] = 'Something went wrong'
    end
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
