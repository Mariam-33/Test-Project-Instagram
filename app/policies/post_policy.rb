# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    super
    @user = user
    @post = post
  end

  def index?
    return true unless @post.exists?

    if @post.first.user.account == 'Private'
      @user == @post.first.user || @post.first.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def show?
    if @post.user.account == 'Private'
      @user == @post.user || @post.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def update?
    @user == @post.user
  end

  def destroy?
    update?
  end
end
