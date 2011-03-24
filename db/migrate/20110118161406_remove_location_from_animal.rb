class RemoveLocationFromAnimal < ActiveRecord::Migration
  def self.up
    # remove_column :animals, :location_id
    # remove_index :animals, :column => :location_id
  end

  def self.down
  end
end
