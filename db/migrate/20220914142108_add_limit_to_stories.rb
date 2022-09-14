class AddLimitToStories < ActiveRecord::Migration[5.2]
  def change
    change_column :stories, :content, :string, :limit => 500
  end
end
