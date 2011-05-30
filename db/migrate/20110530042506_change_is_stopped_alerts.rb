class ChangeIsStoppedAlerts < ActiveRecord::Migration
  def self.up
    rename_column :alerts, :is_stopped, :stopped
  end

  def self.down
  end
end
