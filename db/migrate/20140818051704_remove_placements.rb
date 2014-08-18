class RemovePlacements < ActiveRecord::Migration
  def change
    drop_table :placements
  end
end

