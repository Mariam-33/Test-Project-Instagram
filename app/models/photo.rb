# frozen_string_literal: true

# Photo Model
class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true
  mount_uploader :image, ImageUploader
  validates :image, presence: true
end
