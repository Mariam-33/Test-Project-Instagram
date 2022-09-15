# frozen_string_literal: true

class StoryPolicy < ApplicationPolicy
  attr_reader :user, :story

  def initialize(user, story)
    super
    @user = user
    @story = story
  end

  def index?
    true
  end

  def show?
    @story.user.Public? || @story.user.followers.exists?(follower_id: @user.id, accepted: true)
  end

  def destroy?
    @user == @post.user
  end

  class Scope < Scope
    def resolve
      if @user == @scope.first.user || @scope.first.user.Public? || @scope.first.user.followers.exists?(
        follower_id: @user.id, accepted: true
      )
        scope.all
      else
        []
      end
    end
  end
end
