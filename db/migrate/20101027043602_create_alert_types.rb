class CreateAlertTypes < ActiveRecord::Migration
  def self.up
    create_table :alert_types do |t|
      t.string :name

      t.timestamps
    end
    add_index(:alert_types, :name)
  end

  def self.down
    drop_table :alert_types
    remove_index :alert_types, :column => :name
  end
end
