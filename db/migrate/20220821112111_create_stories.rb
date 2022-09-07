# frozen_string_literal: true

# story table
class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
