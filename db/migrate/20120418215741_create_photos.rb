class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :image
      t.boolean :is_main_photo, :default => false
      t.references :attachable, :polymorphic => true
      t.timestamps
    end
    add_index :photos, :attachable_id
    add_index :photos, :attachable_type
    add_index :photos, [:attachable_id, :attachable_type]
    add_index :photos, [:attachable_id, :is_main_photo]
    add_index :photos, [:attachable_id, :attachable_type, :is_main_photo], :name => :attachable_main_photo
  end

  def self.down
    drop_table :photos
  end
end
