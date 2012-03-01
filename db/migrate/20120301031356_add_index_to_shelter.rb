class AddIndexToShelter < ActiveRecord::Migration
  def self.up
    add_index :shelters, [:id, :status]
    add_index :shelters, [:id, :status, :is_kill_shelter]
    add_index :shelters, [:status, :lat, :lng]
  end

  def self.down
    remove_index :shelters, :column => [:id, :status]
    remove_index :shelters, :column => [:id, :status, :is_kill_shelter]
    remove_index :shelters, :column => [:status, :lat, :lng]
  end
end
