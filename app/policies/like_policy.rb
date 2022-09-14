# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  attr_reader :user, :like

  def initialize(user, like)
    super
    @user = user
    @like = like
  end

  def create?
    if @like.post.user.account == 'Private'
      @user == @like.post.user || @like.post.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def destroy?
    @like.user_id == @user.id
  end
end
