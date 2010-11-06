class CreateAlertTypes < ActiveRecord::Migration
  def self.up
    create_table :alert_types do |t|
      t.string :name

      t.timestamps
    end
    add_index(:alert_types, :name)
    add_index(:alertl_types, :created_at)
  end

  def self.down
    drop_table :alert_types
    remove_index :alert_types, :column => :name
    remove_index :alert_types, :column => :created_at
  end
end
