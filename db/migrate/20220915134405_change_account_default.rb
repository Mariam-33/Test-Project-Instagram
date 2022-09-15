class ChangeAccountDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :account, nil)
  end
end
