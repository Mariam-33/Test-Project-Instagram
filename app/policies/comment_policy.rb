# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    super
    @user = user
    @comment = comment
  end

  def create?
    @comment.post.user.Public? || @user == @comment.post.user || @comment.post.user.followers.exists?(
      follower_id: @user.id, accepted: true
    )
  end

  def edit?
    update?
  end

  def update?
    @comment.user_id == @user.id || @comment.post.user_id == @user.id
  end

  def destroy?
    update?
  end
end
