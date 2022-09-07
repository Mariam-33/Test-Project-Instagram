# frozen_string_literal: true

# Relationships table
class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, foreign_key: true
      t.integer :followed_id, foreign_key: true

      t.timestamps
    end
  end
end
