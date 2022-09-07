# frozen_string_literal: true

# Like Model
class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :user_id, uniqueness: { scope: :post_id }
end
