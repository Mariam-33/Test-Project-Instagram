# frozen_string_literal: true

# polymorphic attribute migration
class AddPloymorphicAttrsToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :photoable_type, :string
    add_column :photos, :photoable_id, :integer
    remove_column :photos, :post_id, :integer
  end
end
