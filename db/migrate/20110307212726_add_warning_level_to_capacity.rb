class AddWarningLevelToCapacity < ActiveRecord::Migration
  def self.up
    add_column :capacities, :warning_level, :string
  end

  def self.down
    remove_column :capacities, :warning_level
  end
end
