class AddIndexToAnimals < ActiveRecord::Migration
  def self.up
    add_index :animals, [:created_at, :shelter_id]
  end

  def self.down
    remove_index :animals, [:created_at, :shelter_id]
  end
end
