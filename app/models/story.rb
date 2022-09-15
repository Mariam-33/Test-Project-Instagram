# frozen_string_literal: true

# Story Model
class Story < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
  validates :content, length: { maximum: 500 }
  validate :validate_images
  after_create_commit :delete_story

  private

  def delete_story
    DeleteStoryJob.set(wait: 24.hours).perform_later(self)
  end

  def validate_images
    errors.add(:base, 'Please attach images with story') if photos.empty?
  end
end
