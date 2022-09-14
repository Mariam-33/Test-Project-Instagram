# frozen_string_literal: true

# Comment Model
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :statement, presence: true, length: { minimum: 5, maximum: 500 }
end
