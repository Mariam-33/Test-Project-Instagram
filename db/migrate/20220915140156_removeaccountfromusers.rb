class Removeaccountfromusers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :account
  end
end
