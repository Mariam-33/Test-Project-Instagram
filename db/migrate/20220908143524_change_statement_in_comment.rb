class ChangeStatementInComment < ActiveRecord::Migration[5.2]
  def change
    change_column_default :comments, :statement, ''
  end
end
