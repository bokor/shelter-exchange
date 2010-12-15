class RemoveCommentsFromPlacements < ActiveRecord::Migration
  def self.up
    remove_column :placements, :comment
  end

  def self.down
  end
end
