class RemoveAlertTypeTable < ActiveRecord::Migration
  def self.up
    drop_table :alert_types
  end

  def self.down
  end
end
