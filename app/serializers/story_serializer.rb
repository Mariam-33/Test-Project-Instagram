# frozen_string_literal: true

class StorySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :content
  has_many :photos, as: :photoable
  belongs_to :user
end
