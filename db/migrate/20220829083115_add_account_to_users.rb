# frozen_string_literal: true

# Migration for adding account field
class AddAccountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account, :string, null: false, default: 'Public'
  end
end
