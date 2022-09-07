# frozen_string_literal: true

# Migration for adding image
class AddImageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image, :string
  end
end
