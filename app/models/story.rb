# frozen_string_literal: true

# Story Model
class Story < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
end
