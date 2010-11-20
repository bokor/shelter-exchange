class AddLongLatToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters,  :lat, :decimal, {:precision => 15, :scale => 10 }
    add_column :shelters,  :lng, :decimal, {:precision => 15, :scale => 10 }
    add_index  :shelters, [:lat, :lng]
  end

  def self.down
    add_column :shelters,  :lat
    remove_column :shelters,  :lng
    remove_index  :shelters, [:lat, :lng]
  end
end
