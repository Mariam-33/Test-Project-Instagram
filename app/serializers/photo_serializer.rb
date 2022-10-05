# frozen_string_literal: true

class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :image, :photoable_type, :photoable_id
  belongs_to :photoable
  belongs_to :stories
end
