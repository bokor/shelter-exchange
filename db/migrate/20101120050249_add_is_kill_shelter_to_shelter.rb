class AddIsKillShelterToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :is_kill_shelter, :boolean, {:default=>false, :null=>false}
  end

  def self.down
    remove_column :shelters, :is_kill_shelter
  end
end
