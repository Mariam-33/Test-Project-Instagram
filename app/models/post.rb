# frozen_string_literal: true

# Post Model
class Post < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validate :limited

  def liked?(user)
    Like.find_by(user_id: user.id, post_id: id)
  end

  private

  def limited
    errors.add(:base, 'Cannot attach more than 10 images') if photos.count > 10
  end
end
