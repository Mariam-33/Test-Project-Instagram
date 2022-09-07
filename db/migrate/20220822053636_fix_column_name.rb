# frozen_string_literal: true

# Coloumn name fix
class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :stories, :description, :content
  end
end
