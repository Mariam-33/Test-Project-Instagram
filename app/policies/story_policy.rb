# frozen_string_literal: true

class StoryPolicy < ApplicationPolicy
  attr_reader :user, :story

  def initialize(user, story)
    super
    @user = user
    @story = story
  end

  def index?
    return true unless @story.exists?

    if @story.first.user.account == 'Private'
      @user == @story.first.user || @story.first.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def show?
    if @story.user.account == 'Private'
      @user == @story.user || @story.user.followers.where(follower_id: @user.id, accepted: true).present?
    else
      true
    end
  end

  def update?
    @user == @story.user
  end

  def destroy?
    update?
  end
end
