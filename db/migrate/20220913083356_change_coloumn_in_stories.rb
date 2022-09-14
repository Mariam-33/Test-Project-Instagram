class ChangeColoumnInStories < ActiveRecord::Migration[5.2]
  def change
    change_column_null :stories, :user_id, false
  end
end
