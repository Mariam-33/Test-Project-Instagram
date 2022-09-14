class ChangeColoumnInPhotos < ActiveRecord::Migration[5.2]
  def change
    change_column_null :photos, :photoable_id, false
    change_column_null :photos, :photoable_type, false
  end
end
