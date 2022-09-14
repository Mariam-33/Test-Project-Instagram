class AddLimitToPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :description, :string, :limit => 500
  end
end
