# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    super
    @user = user
    @post = post
  end

  def index?
    true
  end

  def show?
    @post.user.Public? || @post.user.followers.exists?(follower_id: @user.id, accepted: true)
  end

  def edit?
    update?
  end

  def update?
    @user == @post.user
  end

  def destroy?
    update?
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
