# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  attr_reader :user, :like

  def initialize(user, like)
    super
    @user = user
    @like = like
  end

  def create?
    @like.post.user.Public? || @user == @like.post.user || @like.post.user.followers.exists?(
      follower_id: @user.id, accepted: true
    )
  end

  def destroy?
    @like.user_id == @user.id
  end
end
