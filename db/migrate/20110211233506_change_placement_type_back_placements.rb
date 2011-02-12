class ChangePlacementTypeBackPlacements < ActiveRecord::Migration
  def self.up
    remove_index :placements, [:parent_id, :type]
    remove_index :placements, [:parent_id, :shelter_id, :animal_id]
    rename_column :placements, :type, :placement_type
    add_index(:placements, [:parent_id, :shelter_id, :animal_id])
    add_index(:placements, [:parent_id, :placement_type])
  end

  def self.down
  end
end
