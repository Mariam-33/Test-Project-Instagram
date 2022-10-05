# frozen_string_literal: true

class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :follower_id, :followed_id, :accepted
end
