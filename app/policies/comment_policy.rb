# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    super
    @user = user
    @comment = comment
  end

  def update?
    @post_id = @comment.post_id
    @post = Post.find(@post_id)
    @comment.user_id == @user.id || @post.user_id == @user.id
  end

  def destroy?
    @post_id = @comment.post_id
    @post = Post.find(@post_id)
    @comment.user_id == @user.id || @post.user_id == @user.id
  end
end
