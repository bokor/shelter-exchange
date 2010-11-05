class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.string :title
      t.text :description
      t.references :alertable, :polymorphic => true
      t.references :alert_type

      t.timestamps
    end
    add_index(:alerts, :alertable_id)
    add_index(:alerts, :alertable_type)
    add_index(:alerts, [:alertable_id, :alertable_type])
    add_index(:alerts, :title)
    add_index(:alerts, :description)
  end

  def self.down
    drop_table :alerts
    remove_index :alerts, :column => :alertable_id
    remove_index :alerts, :column => :alertable_type
    remove_index :alerts, :column => [:alertable_id, :alertable_type]
    remove_index :alerts, :column => :title
    remove_index :alerts, :column => :description
  end
end
