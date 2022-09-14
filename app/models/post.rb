# frozen_string_literal: true

# Post Model
class Post < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :description, length: { maximum: 500 }
  validate :validate_image_count

  def liked?(user)
    Like.find_by(user_id: user.id, post_id: id)
  end

  private

  def validate_image_count
    errors.add(:base, 'Please attach images within range of 1-10 per post') if photos.size > 4 || photos.empty?
  end
end
