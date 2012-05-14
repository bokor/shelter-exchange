class UpdateAnimalPhotoName < ActiveRecord::Migration
  def self.up
      rename_column :animals, :photo_file_name, :photo
      remove_column :animals, :photo_content_type
      remove_column :animals, :photo_file_size
      remove_column :animals, :photo_updated_at
  end

  def self.down
  end
end
