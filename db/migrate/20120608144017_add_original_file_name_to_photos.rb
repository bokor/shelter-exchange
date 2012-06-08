class AddOriginalFileNameToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :original_name, :string
  end

  def self.down
    remove_column :photos, :original_name
  end
end
