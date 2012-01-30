class AddVideoToAnimal < ActiveRecord::Migration
  def self.up
    add_column :animals, :video_url, :string
  end

  def self.down
    remove_column :animals, :video_url
  end
end
