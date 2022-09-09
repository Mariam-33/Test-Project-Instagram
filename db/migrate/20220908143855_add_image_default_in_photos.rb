class AddImageDefaultInPhotos < ActiveRecord::Migration[5.2]
  def change
    change_column_default :photos, :image, 'Upload Image'
  end
end
