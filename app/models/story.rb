# frozen_string_literal: true

# Story Model
class Story < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
  after_create :delete_story

  private

  def delete_story
    DeleteStoryJob.set(wait: 24.hours).perform_later(self)
  end
end
