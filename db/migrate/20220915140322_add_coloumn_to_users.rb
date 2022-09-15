class AddColoumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account, :integer, null: false, default: 0
    add_index :users, :account
  end
end
