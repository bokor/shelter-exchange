class ChangePlacementType < ActiveRecord::Migration
  def self.up
    rename_column :placements, :placement_type, :status
  end

  def self.down
  end
end
