# frozen_string_literal: true

# To add index
class AddIndexToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_index :photos, %i[photoable_id photoable_type]
  end
end
