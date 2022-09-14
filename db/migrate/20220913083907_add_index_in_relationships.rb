class AddIndexInRelationships < ActiveRecord::Migration[5.2]
  def change
    add_index :relationships, :accepted
  end
end
