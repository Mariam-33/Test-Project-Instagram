class AddAcceptedToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :accepted, :boolean, :default => false
  end
end
