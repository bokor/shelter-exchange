class AddStoppedToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :is_stopped, :boolean, {:default=>false, :null=>false}
  end

  def self.down
    remove_column :alerts, :is_stopped
  end
end
