class AddIndexToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, [:attachable_id, :is_main_photo, :created_at], :name => :attachable_main_photo_created_at
  end
end
