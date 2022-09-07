# frozen_string_literal: true

# Relationships controller
class DeleteStoryJob < ApplicationJob
  queue_as :default

  def perform(story)
    story.destroy
  end
end
