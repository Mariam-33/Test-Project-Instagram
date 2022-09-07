# frozen_string_literal: true

# Migration for adding bio field
class AddBioToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bio, :text
  end
end
