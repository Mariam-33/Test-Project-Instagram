# frozen_string_literal: true

# Setting image to not null
class ChangeImageInPhotos < ActiveRecord::Migration[5.2]
  def change
    change_column_null :photos, :image, false
  end
end
