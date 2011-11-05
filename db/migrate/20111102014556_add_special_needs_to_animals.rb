class AddSpecialNeedsToAnimals < ActiveRecord::Migration
  def self.up
    add_column :animals, :has_special_needs, :boolean, :default => false, :null => false
    add_column :animals, :special_needs, :text
  end

  def self.down
    remove_column :animals, :has_special_needs
    remove_column :animals, :special_needs
  end
end
