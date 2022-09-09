# frozen_string_literal: true

# Photo Model
class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true
  mount_uploader :image, ImageUploader
  validates :image, presence: true
  validate :image_type

  private

  def image_type
    errors[:base] << 'you tried uploading wrong file' unless image.content_type.in?(%w[image/png image/jpg image/jpeg
                                                                                       image/webp])
  end
end
