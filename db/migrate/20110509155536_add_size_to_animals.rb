class AddSizeToAnimals < ActiveRecord::Migration
  def self.up
    add_column :animals, :size, :string
  end

  def self.down
    remove_column :animals, :size
  end
end
