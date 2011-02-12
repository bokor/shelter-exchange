class ChangePlacementTypeToTypePlacements < ActiveRecord::Migration
  def self.up
    remove_index :placements, [:parent_id, :placement_type]
    remove_index :placements, [:parent_id, :shelter_id, :animal_id]
    rename_column :placements, :placement_type, :type
    add_index(:placements, [:parent_id, :shelter_id, :animal_id])
    add_index(:placements, [:parent_id, :type])
  end

  def self.down
  end
end
