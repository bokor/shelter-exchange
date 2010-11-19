class RemoveAlertTypeForSeverity < ActiveRecord::Migration
  def self.up
    remove_column :alerts, :alert_type_id
    add_column :alerts, :severity, :string
  end

  def self.down
  end
end
