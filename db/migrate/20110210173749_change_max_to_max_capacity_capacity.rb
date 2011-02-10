class ChangeMaxToMaxCapacityCapacity < ActiveRecord::Migration
  def self.up
    rename_column :capacities, :max, :max_capacity
  end

  def self.down
  end
end
