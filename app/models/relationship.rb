# frozen_string_literal: true

# Relationship Model
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, uniqueness: { scope: :followed_id }

  def accept_request(user)
    return unless user.account == 'Public'

    self.accepted = true
  end
end
