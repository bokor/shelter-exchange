class AddColumnsToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :is_broadcast, :boolean
    add_column :alerts, :start_date, :date
    add_column :alerts, :end_date, :date
  end

  def self.down
    remove_column :alerts, :is_broadcast
    remove_column :alerts, :start_date
    remove_column :alerts, :end_date
  end
end