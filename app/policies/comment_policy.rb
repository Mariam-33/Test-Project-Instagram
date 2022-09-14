# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    super
    @user = user
    @comment = comment
  end

  def create?
    if @comment.post.user.account == 'Private'
      @user == @comment.post.user || @comment.post.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def edit?
    update?
  end

  def update?
    @post = Post.find(@comment.post_id)
    @comment.user_id == @user.id || @comment.post.user_id == @user.id
  end

  def destroy?
    update?
  end
end
