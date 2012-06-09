class MoveAnimalPhotosToPhotosModel < ActiveRecord::Migration
  def self.up
    Animal.where("photo IS NOT NULL").reorder(:id).all.each{ |animal|
      photo = Photo.create(:attachable => animal, :is_main_photo => true, :original_name => animal.photo)
      photo.write_uploader(:image, animal.photo)
      photo.save!
    }
    remove_column :animals, :photo
  end

  def self.down
  end
end