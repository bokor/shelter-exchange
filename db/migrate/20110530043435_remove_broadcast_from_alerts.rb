class RemoveBroadcastFromAlerts < ActiveRecord::Migration
  def self.up
    remove_column :alerts, :is_broadcast
  end

  def self.down
  end
end
