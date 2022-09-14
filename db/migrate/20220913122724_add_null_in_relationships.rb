class AddNullInRelationships < ActiveRecord::Migration[5.2]
  def change
    change_column_null :relationships, :accepted, false
  end
end
