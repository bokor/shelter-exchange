class RemoveWarningLevelFromCapacity < ActiveRecord::Migration
  def self.up
    remove_column :capacities, :warning_level
  end

  def self.down
    add_column :capacities, :warning_level, :integer
  end
end
