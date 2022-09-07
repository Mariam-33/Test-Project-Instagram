# frozen_string_literal: true

# Comment Model
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :statement, presence: true
end
