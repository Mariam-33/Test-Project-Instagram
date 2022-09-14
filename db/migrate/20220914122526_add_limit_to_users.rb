class AddLimitToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :username, :string, :limit => 150
  end
end
