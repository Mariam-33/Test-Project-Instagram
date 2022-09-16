# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    super
    @user = user
    @post = post
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
      return [] if scope.empty?

      if verify_user_for_post
        scope.all
      else
        []
      end
    end

    def verify_user_for_post
      scope.first.user.Public? || scope.first.user.followers.exists?(follower_id: @user.id,
                                                                     accepted: true) || scope.first.user == @user
    end
  end
end
