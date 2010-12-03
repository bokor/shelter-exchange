class ChangeTypeToPlacementParentHistories < ActiveRecord::Migration
  def self.up
    rename_column :parent_histories, :type, :placement_type
  end

  def self.down
  end
end
