class AddColumnsToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :is_broadcast, :boolean, :default => false
  end

  def self.down
    remove_column :alerts, :is_broadcast
  end
end